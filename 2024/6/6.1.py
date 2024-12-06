import numpy as np

A = np.fromfile("6.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]
height = A.shape[0]


class C(object):
    POUND = ord("#")
    DOT = ord(".")
    X = ord("X")


pos = tuple(np.argwhere(A == ord("^"))[0])
A[pos] = C.X
dir = "up"


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
    if r < 0 or r >= height or c < 0 or c >= width:
        raise BadBoundsError
    return r, c


rot90 = {"up": "right", "right": "down", "down": "left", "left": "up"}


while True:
    try:
        next_pos = forward(pos, dir)
    except BadBoundsError:
        break
    next_block = A[next_pos].item()

    match next_block:
        case C.POUND:
            dir = rot90[dir]
        case C.DOT | C.X:
            pos = next_pos
            A[pos] = C.X

print((A == C.X).sum())
