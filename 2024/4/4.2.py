import numpy as np

A = np.fromfile("4.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]

patches = np.lib.stride_tricks.sliding_window_view(A, (3, 3)).reshape((-1, 3, 3))
xmas = np.asarray([ord(c) for c in "M S A M S"], dtype=np.ubyte).reshape((3, 3))

all_xmases = np.stack([xmas, np.flip(xmas, 1), xmas.T, np.flip(xmas.T, 0)])
diffs = patches[:, None, ...] - all_xmases[None, ...]
zero_sums = (diffs == 0).sum(2).sum(2)

count = (zero_sums == 5).sum()
print(count)
