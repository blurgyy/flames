#!/usr/bin/env python3

import os
import subprocess
import sys


session_manager_service_name = (
    # NOTE: wireplumber is the recommended session manager over pipewire-media-session
    "wireplumber"
    # "pipewire-media-session"
)

stop_services = [
    "pipewire",
    "xdg-desktop-portal",
    "xdg-desktop-portal-wlr",
    session_manager_service_name,
]

start_services = [
    session_manager_service_name,
]


def main(current_desktop_name: str) -> int:
    print(
        "updating activation environment via dbus: "
        "WAYLAND_DISPLAY={}, XDG_CURRENT_DESKTOP={}".format(
        os.environ["WAYLAND_DISPLAY"],
        current_desktop_name,
    ))
    subprocess.run([
        "dbus-update-activation-environment",
        "--systemd",
        "WAYLAND_DISPLAY",
        "XDG_CURRENT_DESKTOP={}".format(current_desktop_name),
    ], check=True)

    print("stopping the following service(s): {}".format(", ".join(stop_services)))
    subprocess.run([
        "systemctl",
        "--user",
        "stop",
    ] + stop_services, check=True)

    print("starting the following service(s): {}".format(", ".join(start_services)))
    subprocess.run([
        "systemctl",
        "--user",
        "start",
    ] + start_services, check=True)
    return 0


if __name__ == "__main__":
    try:
        _, current_desktop_name = sys.argv
    except:
        print("usage: {} <current_desktop_name>".format(sys.argv[0]), file=sys.stderr)
        exit(255)

    exit(main(current_desktop_name))
