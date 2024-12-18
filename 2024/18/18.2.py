import numpy as np
from tqdm import tqdm

# fn, size, nbytes = "18.test", 7, 12
fn, size, nbytes = "18.txt", 71, 1024

falling_bytes = np.loadtxt(fn, delimiter=",", dtype=int)

A = np.zeros((size, size), dtype=int) - 1


class BadBoundsError(Exception):
    pass


def forward(pos, dir):
    r, c = pos
    match dir:
        case "up":
            r -= 1
        case "right":
            c += 1
        case "down":
            r += 1
        case "left":
            c -= 1
    if r < 0 or r >= size or c < 0 or c >= size:
        raise BadBoundsError
    return r, c


def get_neighboring_positions(pos):
    for dir in ["up", "right", "down", "left"]:
        try:
            yield forward(pos, dir)
        except BadBoundsError:
            continue


def flood_fill(A):
    positions = [(0, 0)]
    for dist in range(0, size**2):
        next_positions = []
        for pos in positions:
            if A[pos] == -1:
                A[pos] = dist
                for step in get_neighboring_positions(pos):
                    next_positions.append(step)
        positions = next_positions


def print_grid(A):
    for i in range(A.shape[0]):
        for j in range(A.shape[1]):
            match A[i, j]:
                case -2:
                    s = "#"
                case -1:
                    s = "."
                case _:
                    s = chr(ord("a") + A[i, j])
            print(s, end="")
        print("")


# brute forcing takes only around 10s...
for c, r in tqdm(falling_bytes):
    if A[r, c] != -2:
        A[r, c] = -2
        B = A.copy()
        flood_fill(B)
        if B[-1, -1] == -1:
            break

print(f"{c},{r}")
