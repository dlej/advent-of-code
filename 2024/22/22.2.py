from collections import defaultdict
from functools import cache

import numpy as np
from tqdm import tqdm

buyers = [int(x) for x in np.loadtxt("22.txt", dtype=int)]


def mix_and_prune(m, n):
    return (m ^ n) % 16777216


@cache
def evolve_secret(n):
    n = mix_and_prune(n << 6, n)
    n = mix_and_prune(n >> 5, n)
    n = mix_and_prune(n << 11, n)
    return n


prices = {}
for k, n in enumerate(tqdm(buyers)):
    prices[k] = np.zeros(2001, dtype=int)
    prices[k][0] = n % 10
    for i in range(1, 2000 + 1):
        n = evolve_secret(n)
        prices[k][i] = n % 10

diffs = {k: np.diff(v) for k, v in prices.items()}

matches = defaultdict(dict)

for k, diff in tqdm(diffs.items()):
    for i in range(len(diff) - 3):
        seq = tuple(diff[i : i + 4])
        price = prices[k][i + 4]
        if k not in matches[seq]:
            matches[seq][k] = price

print(max(sum(v.values()) for v in matches.values()))
