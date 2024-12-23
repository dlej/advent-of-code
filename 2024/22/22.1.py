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


s = 0
for n in tqdm(buyers):
    for _ in range(2000):
        n = evolve_secret(n)
    s += n

print(s)
