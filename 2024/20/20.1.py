from collections import Counter
import numpy as np
from tqdm import tqdm

A = np.fromfile("20.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]
height = A.shape[1]

A = A.astype(int)
for i, c in enumerate(".#SE"):
    A[A == ord(c)] = -(i + 1)

start = tuple(np.argwhere(A == -3)[0])
end = tuple(np.argwhere(A == -4)[0])


class BadBoundsError(Exception):
    pass


def forward(A, pos, dir):
    height, width = A.shape
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
    if r < 0 or r >= width or c < 0 or c >= height:
        raise BadBoundsError
    return r, c


def get_neighboring_positions(A, pos):
    for dir in ["up", "right", "down", "left"]:
        try:
            yield forward(A, pos, dir)
        except BadBoundsError:
            continue


def get_double_neighboring_positions(A, pos):
    seen = {pos}
    for step in get_neighboring_positions(A, pos):
        for step2 in get_neighboring_positions(A, step):
            if step2 not in seen:
                yield step2
                seen.add(step2)


def flood_fill(A: np.ndarray, start=(0, 0)) -> np.ndarray:
    A = A.copy()
    positions = [start]
    A[start] = 0
    for dist in range(1, A.size):
        next_positions = []
        for pos in positions:
            for step in get_neighboring_positions(A, pos):
                if A[step] == -1:
                    A[step] = dist
                    next_positions.append(step)
                elif A[step] == -4:
                    A[step] = dist
        positions = next_positions
    return A


def print_grid(A):
    for i in range(A.shape[0]):
        for j in range(A.shape[1]):
            match A[i, j]:
                case -1:
                    s = "."
                case -2:
                    s = "#"
                case -3:
                    s = "S"
                case -4:
                    s = "E"
                case -5:
                    s = "@"
                case _:
                    if A[i, j] % 10 == 0:
                        s = chr(ord("a") + A[i, j] // 10 - 1)
                    else:
                        s = str(A[i, j] % 10)
            print(s, end="")
        print("")


B1 = flood_fill(A, start)
length = B1[end]
B2 = flood_fill(A, end)

places = np.argwhere(np.logical_or(A == -1, A == -3))

cheats = Counter()
for r, c in tqdm(places):
    for step in get_double_neighboring_positions(A, (r, c)):
        if A[step] == -1 or A[step] == -4:
            cheats[length - (B1[r, c] + B2[step] + 2)] += 1

print(sum(v for k, v in cheats.items() if k >= 100))
