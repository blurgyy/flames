#!/usr/bin/env python3

from concurrent.futures import ThreadPoolExecutor
import dataclasses
import ipaddress
import json
from pathlib import Path
import sys
from typing import Any, Dict

import icmplib


@dataclasses.dataclass(kw_only=True, frozen=True)
class WarpEndpoint:
    address: ipaddress.IPv4Address
    port: int

    def __post_init__(self) -> None:
        assert 0 < self.port < 65536, "Port must be between 1 and 65535"

    def __repr__(self) -> str:
        return f"{self.address}:{self.port}"

    @staticmethod
    def from_repr(repr: str) -> "WarpEndpoint":
        address, port = repr.split(":")
        return WarpEndpoint(
            address=ipaddress.IPv4Address(address),
            port=int(port),
        )


@dataclasses.dataclass(kw_only=True, frozen=True)
class WarpSettings:
    version: int
    always_on: bool
    operation_mode: Dict[str, Any]
    proxy_port: int
    override_warp_endpoint: WarpEndpoint

    def __post_init__(self) -> None:
        assert 0 < self.proxy_port < 65536, "Port must be between 1 and 65535"

    @staticmethod
    def deserialize(loaded: dict) -> "WarpSettings":
        return WarpSettings(
            version=loaded["version"],
            always_on=loaded["always_on"],
            operation_mode=loaded["operation_mode"],
            proxy_port=loaded["proxy_port"],
            override_warp_endpoint=WarpEndpoint.from_repr(loaded["override_warp_endpoint"]),
        )

    def serialize(self) -> Dict[str, Any]:
        serialized = dataclasses.asdict(self)
        serialized["override_warp_endpoint"] = repr(self.override_warp_endpoint)
        return serialized 


@dataclasses.dataclass(kw_only=True, frozen=True)
class AddressWithHost:
    addr: ipaddress.IPv4Address
    host: icmplib.Host


default_warp_settings = WarpSettings(
    version=1,
    always_on=True,
    operation_mode={"WarpProxy": None},
    proxy_port=3856,
    override_warp_endpoint=WarpEndpoint(
        address=ipaddress.IPv4Address("162.159.192.254"),
        port=2408,
    ),
)
cloudflare_warp_endpoints = ipaddress.IPv4Network("162.159.192.0/24")


def server_ping_time(addr: ipaddress.IPv4Address) -> AddressWithHost:
    addr = ipaddress.IPv4Address(addr)
    host = icmplib.ping(str(addr), count=3, interval=.8, timeout=1., privileged=False)
    return AddressWithHost(addr=addr, host=host)


def main(proxy_port: int, settings_json_path: Path) -> int:
    num_ips_to_test = 2 ** (32 - cloudflare_warp_endpoints.prefixlen)

    exe = ThreadPoolExecutor(max_workers=num_ips_to_test)
    address_with_host_list = list(exe.map(server_ping_time, cloudflare_warp_endpoints))
    if all(not x.host.is_alive for x in address_with_host_list):
        raise RuntimeError("No Cloudflare WARP endpoints are reachable")

    address_with_host_list = sorted(address_with_host_list, key=lambda x: x.host.avg_rtt + 1e9 * (1 - x.host.is_alive))

    if settings_json_path.exists():
        warp_settings = WarpSettings.deserialize(json.load(open(settings_json_path)))
        settings_json_path.unlink()
    else:
        warp_settings = default_warp_settings

    warp_settings = dataclasses.replace(
        warp_settings,
        override_warp_endpoint=WarpEndpoint(
            address=address_with_host_list[0].addr,
            port=2408,
        ),
        proxy_port=proxy_port,
    )

    json.dump(warp_settings.serialize(), open(settings_json_path, "w"), separators=(",", ":"))

    return 0

if __name__ == "__main__":
    try:
        _, proxy_port, settings_json_path = sys.argv
    except:
        print("Usage: {} <proxy_port> <settings_json_path>".format(sys.argv[0]), file=sys.stderr)
        exit(1)

    proxy_port, settings_json_path = int(proxy_port), Path(settings_json_path)

    assert 0 < proxy_port < 65536, "Port must be between 1 and 65535"

    exit(main(proxy_port=proxy_port, settings_json_path=settings_json_path))
