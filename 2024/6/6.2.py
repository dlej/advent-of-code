import numpy as np

A = np.fromfile("6.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]
height = A.shape[0]

# bitwise encoding:
# 0b00000 = free
# 0b00001 = traveled up
# 0b00010 = traveled right
# 0b00100 = traveled down
# 0b01000 = traveled left
# 0b10000 = occupied


class D(object):
    UP = 0b0001
    RIGHT = 0b0010
    DOWN = 0b0100
    LEFT = 0b1000


A[A == ord(".")] = 0b00000
A[A == ord("#")] = 0b10000

start_pos = tuple(np.argwhere(A == ord("^"))[0])
pos = start_pos
A[pos] = D.UP
dir = D.UP


class BadBoundsError(Exception):
    pass


def forward(pos, dir):
    r, c = pos
    match dir:
        case D.UP:
            r -= 1
        case D.RIGHT:
            c += 1
        case D.DOWN:
            r += 1
        case D.LEFT:
            c -= 1
    if r < 0 or r >= height or c < 0 or c >= width:
        raise BadBoundsError
    return r, c


def rot90(d):
    d <<= 1
    return (d & 0b1111) | (d >> 4)


def has_loop(B, pos, dir):
    while True:
        try:
            next_pos = forward(pos, dir)
        except BadBoundsError:
            return False
        next_block = B[next_pos].item()

        if next_block & 0b10000 != 0:
            dir = rot90(dir)
            B[pos] |= dir
        elif next_block & dir != 0:
            return True
        else:
            pos = next_pos
            B[pos] |= dir


def print_bin(A):
    for row in A:
        print(" ".join(f"{v:05b}" for v in row))


loop_locs = set()

while True:
    try:
        next_pos = forward(pos, dir)
    except BadBoundsError:
        break
    next_block = A[next_pos].item()

    # try hypothetical path with obstruction in front of us
    # note that we can't place one where we've already walked,
    # because then we'd never get here!
    if next_pos != start_pos and next_block & 0b11111 == 0:
        B = A.copy()
        B[next_pos] = 0b10000
        if has_loop(B, pos, dir):
            loop_locs.add(next_pos)

    if next_block & 0b10000 != 0:
        dir = rot90(dir)
        A[pos] |= dir
    else:
        pos = next_pos
        A[pos] |= dir

print(len(loop_locs))
