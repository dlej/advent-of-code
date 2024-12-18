import re

import numpy as np

A = np.fromfile("4.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]


def join(arrs, fill=32):
    arrs = list(arrs)
    concats = [arrs.pop(0)]
    while len(arrs) > 0:
        concats.append([fill])
        concats.append(arrs.pop(0))
    return np.concatenate(concats)


def extract_diags(A):
    m, n = A.shape
    offsets = np.concatenate([np.arange(-m + 1, 0), np.arange(n)])
    return [np.diagonal(A, off) for off in offsets]


def ord2str(arr):
    return "".join(chr(x) for x in arr)


four_ways = [A, A.T, extract_diags(A), extract_diags(np.flip(A, 0))]

count = 0
for way in four_ways:
    s = ord2str(join(way))
    count += len(re.findall("XMAS", s))
    count += len(re.findall("XMAS", s[::-1]))

print(count)
