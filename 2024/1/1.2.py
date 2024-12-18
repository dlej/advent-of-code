from collections import defaultdict
import numpy as np

X = np.loadtxt("1.txt", delimiter=" ", dtype=object)
x1 = np.sort(X[:, 0].astype(int))
x2 = np.sort(X[:, -1].astype(int))

factors = defaultdict(lambda: [0, 0])

for u, c in zip(*np.unique(x1, return_counts=True)):
    factors[u][0] = c
for u, c in zip(*np.unique(x2, return_counts=True)):
    factors[u][1] = c

print(sum(k * v1 * v2 for k, (v1, v2) in factors.items()))
