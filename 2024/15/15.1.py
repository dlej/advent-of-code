import numpy as np


class C(object):
    DOT = ord(".")
    WALL = ord("#")
    BOX = ord("O")
    ROBOT = ord("@")


map_str = ""
directions = []

with open("15.txt", "r") as f:
    reading_map = True
    for line in f.readlines():
        line = line.strip()
        if line == "":
            reading_map = False
        if reading_map:
            map_str += line
            width = len(line)
        else:
            directions.extend([c for c in line])

A = np.frombuffer(map_str.encode(), dtype=np.ubyte).copy()
A = A.reshape((-1, width))[:, :width]
height = A.shape[0]


def get_forward_slice_and_step(pos, dir):
    r, c = pos
    match dir:
        case "^":
            return (slice(r, None, -1), c), (r - 1, c)
        case ">":
            return (r, slice(c, None)), (r, c + 1)
        case "v":
            return (slice(r, None), c), (r + 1, c)
        case "<":
            return (r, slice(c, None, -1)), (r, c - 1)


def print_map():
    for a in A:
        for x in a:
            print(chr(x), end="")
        print("")


pos = tuple(np.argwhere(A == C.ROBOT)[0])

for dir in directions:
    forward_slice, step = get_forward_slice_and_step(pos, dir)
    forward_view = A[forward_slice]
    for i, x in enumerate(forward_view):
        match x:
            case C.DOT:
                new_forward_view = np.concatenate(
                    [[C.DOT], forward_view[:i], forward_view[i + 1 :]]
                )
                A[forward_slice] = new_forward_view
                forward_view[0] = C.DOT
                pos = step
                break
            case C.WALL:
                break


print(sum(100 * r + c for r, c in np.argwhere(A == C.BOX)))
