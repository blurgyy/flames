#!/usr/bin/env python3

import argparse
from http.server import BaseHTTPRequestHandler, HTTPServer
from typing import Any, Dict
from urllib.parse import urlparse


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
        char = all_choices[(index ** 2) % len(all_choices)]
        handle.append(char)
        pos, old_index = index % len(hashed), index

    handle = "".join(handle)

    return handle


class ConfigServer(BaseHTTPRequestHandler):
    template: str
    users: Dict[str, str]

    def __init__(self, *args: Any, **kwargs: Any) -> None:
        self.template = kwargs.pop('template', '')
        self.users = kwargs.pop('users', {})
        super().__init__(*args, **kwargs)

    def do_GET(self) -> None:
        parsed_path = urlparse(self.path)
        if parsed_path.path.startswith('/api/v1/_handle/'):
            self.handle_api_request(parsed_path.path)
        elif parsed_path.path.startswith('/'):
            self.handle_hash_request(parsed_path.path[1:])
        else:
            self.send_error(404)

    def handle_api_request(self, path: str) -> None:
        parts = path.split('/')
        if len(parts) != 6:
            self.send_error(400)
            return

        name = parts[4]
        try:
            length = int(parts[5])
            if length <= 0:
                raise ValueError
        except ValueError:
            self.send_error(400)
            return

        hash_value = username_to_handle(name, length)

        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(f'{{"hash": "{hash_value}"}}'.encode())

    def handle_hash_request(self, hash_prefix: str) -> None:
        if len(hash_prefix) < 6:
            self.send_error(400)
            return

        for name, uuid in self.users.items():
            computed_hash = username_to_handle(name, len(hash_prefix))
            if computed_hash == hash_prefix:
                with open(self.template, 'r') as f:
                    config = f.read()
                config = config.replace('@@uuid@@', uuid)

                self.send_response(200)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(config.encode())
                return

        self.send_error(404)


def load_users(file_path: str) -> Dict[str, str]:
    users = {}
    with open(file_path, 'r') as f:
        for line in f:
            name, uuid = line.strip().split('=')
            users[name] = uuid
    return users


def main(template: str, users_spec: str, host: str, port: int) -> int:
    users = load_users(users_spec)
    server_address = (host, port)
    httpd = HTTPServer(server_address, lambda *args, **kwargs: ConfigServer(*args, template=template, users=users, **kwargs))
    print(f"Server running on http://{host}:{port}")
    httpd.serve_forever()
    return 0


def make_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Config HTTP Server")
    parser.add_argument("--template", required=True, help="Path to the config template")
    parser.add_argument("--users", required=True, help="Path to the file containing user names and UUIDs")
    parser.add_argument("--listen", default="127.0.0.1", help="Server listening address")
    parser.add_argument("--port", type=int, default=8000, choices=range(1, 65536), metavar="[1-65535]", help="Server listening port")
    return parser


if __name__ == "__main__":
    args = make_parser().parse_args()
    exit(main(args.template, args.users, args.listen, args.port))
