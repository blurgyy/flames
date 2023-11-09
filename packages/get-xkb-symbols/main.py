#!/usr/bin/env python3

import sys
from pathlib import Path


def main(xkbsrc: Path, outpath: Path) -> int:
    with open(xkbsrc, "r") as f:
        content = f.read()

    pattern = "xkb_symbols"
    start = content.find(pattern)

    if start == -1:
        print(f"could not find '{pattern}' in the given file '{xkbsrc.as_posix()}'")
        return 1

    left_brace_index, right_brace_index = -1, -1
    for i in range(start, len(content)):
        if left_brace_index == -1 and content[i] == "{":
            left_brace_index = i
        elif content[i] == "{":
            right_brace_index -= 1
        elif content[i] == "}":
            right_brace_index += 1

        if right_brace_index == 0:
            right_brace_index = i
            break

    xkb_symbols_content = content[start:right_brace_index + 1] + ";"

    outpath.parent.mkdir(exist_ok=True, parents=True)
    outpath.write_text(xkb_symbols_content)

    return 0


if __name__ == "__main__":
    try:
        _, xkbsrc, outpath = sys.argv
    except:
        print("Usage: {} <xkbsrc> <outpath>".format(sys.argv[0]), file=sys.stderr)
        exit(255)

    xkbsrc, outpath = map(Path, [xkbsrc, outpath])

    exit(main(xkbsrc, outpath))
