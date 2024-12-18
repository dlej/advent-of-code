from itertools import combinations
import numpy as np

A = np.fromfile("8.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]
height = A.shape[0]

A[A == ord(".")] = 0
B = np.zeros_like(A)

nz_vals = np.unique(A[A > 0])


def is_in_bounds(r, c):
    return 0 <= r < height and 0 <= c < width


for val in nz_vals:
    locs = np.argwhere(A == val)
    for (r1, c1), (r2, c2) in combinations(locs, 2):
        dr, dc = r1 - r2, c1 - c2
        while is_in_bounds(r1 + dr, c1 + dc):
            r1 += dr
            c1 += dc
        while is_in_bounds(r1, c1):
            B[r1, c1] += 1
            r1 -= dr
            c1 -= dc

print((B > 0).sum())
