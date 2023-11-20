#!/usr/bin/env python3

from functools import partial
import json
from pathlib import Path
import sys
from typing import List


def txt_as_list(path: Path) -> List[str]:
    with open(path) as f:
        return list(map(str.strip, f.readlines()))


def populate_rules(obj: dict, rules_dir: Path) -> dict:
    if not isinstance(obj, dict):
        return obj
    ret = obj.copy()
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
                if ":" in file_spec:
                    stem, variant = file_spec.split(":")
                    path = rules_dir.joinpath("{}.txt".format(stem))
                    prefix = "{}:".format(variant)
                    rules += [entry[len(prefix):] for entry in txt_as_list(path) if entry.startswith(prefix)]
                else:
                    path = rules_dir.joinpath("{}.txt".format(file_spec))
                    rules += [entry for entry in txt_as_list(path) if ":" not in entry]
            ret[key] = list(set(rules))
        elif isinstance(value, dict):
            ret[key] = populate_rules(value, rules_dir)
        elif isinstance(value, list):
            ret[key] = list(map(partial(populate_rules, rules_dir=rules_dir), value))
        else:
            ret[key] = value
    return ret


def main(rules_dir: Path, cfg_path: Path) -> int:
    cfg = json.load(open(cfg_path))
    cfg = populate_rules(cfg, rules_dir)
    json.dump(cfg, open(cfg_path, "w"))
    return 0


if __name__ == "__main__":
    try:
        _, rules_dir, cfg_path = sys.argv
    except:
        print(
            "usage: {} <rules_dir> <cfg_path>".format(sys.argv[0]),
            file=sys.stderr,
        )
        exit(1)

    rules_dir, cfg_path = map(Path, [rules_dir, cfg_path])
    exit(main(rules_dir, cfg_path))
