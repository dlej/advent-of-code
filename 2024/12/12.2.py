from collections import defaultdict
import numpy as np
from scipy.sparse import lil_array

A = np.fromfile("12.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]
height = A.shape[0]


def is_in_bounds(r, c):
    return 0 <= r < height and 0 <= c < width


def get_neighbors(r, c, bounds_check=True):
    neighbors = []
    for r_, c_ in [(r - 1, c), (r, c + 1), (r + 1, c), (r, c - 1)]:
        if is_in_bounds(r_, c_) or not bounds_check:
            neighbors.append((r_, c_))
    return neighbors


class Region(set):
    plant_type: int

    def __init__(self, plant_type: int):
        self.plant_type = plant_type
        super().__init__()

    def area(self):
        return len(self)

    def perimeter(self):
        return sum(4 - sum(p in self for p in get_neighbors(*pos)) for pos in self)

    def __repr__(self):
        return f'Region("{chr(self.plant_type)}", {sorted(self)})'


def idx2pos(i):
    return divmod(i, width)


# build graph
G = lil_array((height * width,) * 2)
for i in range(height):
    for j in range(width):
        for r, c in get_neighbors(i, j):
            if A[i, j] == A[r, c]:
                G[i * width + j, r * width + c] = 1


regions = []

# find regions
for v in np.unique(A):
    idx = np.argwhere(A == v)
    G_idx = idx @ np.array([width, 1])
    G_sub = G[G_idx, :][:, G_idx].toarray()
    n = len(G_idx)

    to_check = set(range(n))
    while len(to_check) > 0:
        s = {next(iter(to_check))}
        r = Region(v)
        while len(s) > 0:
            i = s.pop()
            to_check.remove(i)
            r.add(idx2pos(G_idx[i]))
            for j in G_sub[:, i].nonzero()[0]:
                if idx2pos(G_idx[j]) not in r:
                    s.add(j)
        regions.append(r)


# count sides
s = 0
for region in regions:
    fences = defaultdict(lambda: defaultdict(set))
    for i, j in region:
        for p in get_neighbors(i, j, bounds_check=False):
            if p not in region:
                r, c = p
                if i == r:
                    fences[i - r, j - c][j].add(i)
                else:
                    fences[i - r, j - c][i].add(j)

    n_sides = 0
    for d in fences.values():
        for vs in d.values():
            n_sides += 1 + sum(np.diff(sorted(vs)) > 1)

    s += region.area() * n_sides

print(s)
