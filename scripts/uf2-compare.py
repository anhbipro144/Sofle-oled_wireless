#!/usr/bin/env python3
"""Compare a bootloader dump (CURRENT.UF2) with built .uf2 files, block by block.
Usage: scripts/uf2-compare.py /Volumes/NICENANO/CURRENT.UF2 firmware.uf2 [more.uf2 ...]
"0 differing" = that firmware is exactly what is installed. Read-only; never writes to the drive."""
import struct, sys


def load(path):
    data, blocks = open(path, "rb").read(), {}
    for i in range(0, len(data), 512):
        block = data[i:i + 512]
        addr, size = struct.unpack("<II", block[12:20])  # UF2 header: target address, payload size
        blocks[addr] = block[32:32 + size]
    return blocks


dump = load(sys.argv[1])
for path in sys.argv[2:]:
    fw = load(path)
    diff = sum(1 for addr, payload in fw.items() if dump.get(addr) != payload)
    print(f"{diff:5} of {len(fw)} blocks differing  {path}")
