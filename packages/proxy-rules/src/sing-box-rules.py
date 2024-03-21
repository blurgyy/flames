#!/usr/bin/env python3

from copy import deepcopy
from dataclasses import dataclass
from functools import partial
import json
import math
import os
from pathlib import Path
import sys
from typing import List, Literal

from fastapi import FastAPI, HTTPException


@dataclass(frozen=True, kw_only=True)
class User:
    username: str
    uuid: str


def txt_as_list(path: Path) -> List[str]:
    with open(path) as f:
        return list(map(str.strip, f.readlines()))


def apply_prepend_char(rules: List[str], prepend_char: str) -> List[str]:
    return list(map(
        lambda entry: "{}{}".format(prepend_char, entry),
        rules,
    ))


def populate_rules(obj: dict, rules_dir: Path) -> dict:
    if not isinstance(obj, dict):
        return obj
    ret = deepcopy(obj)
    for key, value in obj.items():
        if isinstance(value, str) and len(value) > 2 and value.startswith("@") and value.endswith("@"):
            rules_file_specs = value[1:-1].strip()
            rules_file_specs = rules_file_specs.replace(",", "+")
            rules_file_specs = list(filter(
                lambda path: len(path) > 0,
                map(str.strip, rules_file_specs.split("+")),
            ))
            rules = []
            for file_spec in rules_file_specs:
                prepend_char = ""
                if "#" in file_spec:
                    if ":" in file_spec:
                        assert file_spec.count(":") == 1, "Must specify at most one variant rule"
                        assert file_spec.index(":") < file_spec.index("#"), "Must specify variant rule (:) before prepend rule (#)"
                    file_spec, prepend_char = file_spec.split("#")
                if ":" in file_spec:
                    stem, variant = file_spec.split(":")
                    path = rules_dir.joinpath("{}.txt".format(stem))
                    prefix = "{}:".format(variant)
                    rules += apply_prepend_char(
                        [entry[len(prefix):] for entry in txt_as_list(path) if entry.startswith(prefix)],
                        prepend_char=prepend_char,
                    )
                else:
                    path = rules_dir.joinpath("{}.txt".format(file_spec))
                    rules += apply_prepend_char(
                        [entry for entry in txt_as_list(path) if ":" not in entry],
                        prepend_char=prepend_char,
                    )
            ret[key] = list(set(rules))
        elif isinstance(value, dict):
            ret[key] = populate_rules(value, rules_dir)
        elif isinstance(value, list):
            ret[key] = list(map(partial(populate_rules, rules_dir=rules_dir), value))
        else:
            ret[key] = value
    return ret


def username_to_handle(username, handle_length) -> str:
    """
    Maps an arbitrary string into another 6-character string with a deterministic hash function.
    The resulting string will contain exactly 2 digits, 2 lower-case letters, and 2 upper case letters.
    The order of the 6 characters can be arbitrary, as long as the mapping is deterministic.
    """
    import hashlib
    import string

    # Hash the username using BLAKE2
    hasher = hashlib.blake2b()
    hasher.update(username.encode('utf-8'))
    hashed = hasher.hexdigest()

    all_choices = string.digits + string.ascii_lowercase + string.ascii_uppercase

    handle, pos, old_index = [], 0, 0

    while len(handle) < handle_length:
        index = int(f"0{hashed[pos:pos+16]}", 16) ^ (998_244_353 * old_index)
        char = all_choices[index % len(all_choices)]
        handle.append(char)
        pos, old_index = index % len(hashed), index

    handle = "".join(handle)

    return handle


def replace_uuid(cfg: dict, uuid: str) -> dict:
    if not isinstance(cfg, dict):
        return cfg
    ret = deepcopy(cfg)
    for key, value in cfg.items():
        if key == "uuid":
            ret[key] = uuid
        elif isinstance(value, dict):
            ret[key] = replace_uuid(value, uuid)
        elif isinstance(value, list):
            ret[key] = list(map(partial(replace_uuid, uuid=uuid), value))
        else:
            pass
    return ret


def modify_set_system_proxy(cfg: dict) -> dict:
    ret = deepcopy(cfg)
    inbounds = ret["inbounds"]
    new_inbounds = []
    for inbound in inbounds:
        if inbound["type"] == "tun":
            continue
        if inbound["type"] == "http":
            inbound["set_system_proxy"] = True
        new_inbounds.append(inbound)
    ret["inbounds"] = new_inbounds
    return ret


def populate(rules_dir: Path, cfg_path: Path) -> int:
    cfg = json.loads(cfg_path.read_text())
    cfg = populate_rules(cfg, rules_dir)
    cfg_path.write_text(json.dumps(cfg))
    return 0


def serve(rules_dir: Path, template_path: Path, userids_path: Path) -> int:
    template = json.loads(template_path.read_text())
    populated = populate_rules(template, rules_dir)

    handle_to_user = {
        username_to_handle(line.split("=")[0], handle_length=6): User(
            username=line.split("=")[0],
            uuid=line.split("=")[1],
        )
        for line in filter(
            lambda line: len(line.strip()) > 0,
            userids_path.read_text().split("\n"),
        )
    }

    app = FastAPI()

    @app.get("/api/v1/_handle/{username}/{handle_length}")
    def get_handle(username: str, handle_length: int):
        return username_to_handle(username, handle_length=handle_length)

    @app.get("/{salty_handle}")
    def serve_config(salty_handle: str, set_system_proxy: bool=False):
        for handle in handle_to_user.keys():
            if handle in salty_handle:
                if set_system_proxy:
                    cfg = modify_set_system_proxy(populated)
                else:
                    cfg = populated
                return replace_uuid(cfg, handle_to_user[handle].uuid)
        raise HTTPException(status_code=404)

    import uvicorn

    class Server(uvicorn.Server):
        def install_signal_handlers(self):
            pass

    Server(uvicorn.Config(
        app,
        host=os.environ.get("SING_BOX_RULES_HOST", "127.0.0.1"),
        port=os.environ.get("SING_BOX_RULES_PORT", 2983),
        log_level="info",
    )).run()

    return 0


def main(subcommand: Literal["populate", "serve"], args: List[str]) -> int:
    if subcommand == "populate":
        try:
            rules_dir, cfg_path = args
        except:
            print(
                "usage: {} populate <rules_dir> <cfg_path>".format(sys.argv[0]),
                file=sys.stderr,
            )
            return 2
        rules_dir, cfg_path = map(Path, [rules_dir, cfg_path])
        return populate(rules_dir, cfg_path)
    elif subcommand == "serve":
        try:
            rules_dir, template_json_path, userids_path = args
        except:
            print(
                "usage: {} serve <rules_dir> <template_json_path> <userids_path>".format(sys.argv[0]),
                file=sys.stderr,
            )
            return 2
        rules_dir, template_json_path, userids_path = map(Path, [rules_dir, template_json_path, userids_path])
        return serve(rules_dir, template_json_path, userids_path)
    else:
        print(
            "unrecognized subcommand: {}".format(subcommand),
            file=sys.stderr,
        )
        return 2

    return 0


if __name__ == "__main__":
    try:
        _, subcommand, *args = sys.argv
    except:
        print(
            "usage: {} <populate|serve> ...".format(sys.argv[0]),
            file=sys.stderr,
        )
        exit(1)

    exit(main(subcommand, args))
