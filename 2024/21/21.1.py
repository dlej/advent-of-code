from heapq import heappop, heappush
from typing import Generator

import numpy as np

codes = []
with open("21.txt", "r") as f:
    for line in f.readlines():
        codes.append(line.strip())


D_PAD = np.asarray([["", "^", "A"], ["<", "v", ">"]])
NUM_PAD = np.asarray(
    [["7", "8", "9"], ["4", "5", "6"], ["1", "2", "3"], ["", "0", "A"]]
)


class BadBoundsError(Exception):
    pass


def forward(A: np.ndarray, pos: tuple[int], dir: str):
    height, width = A.shape
    r, c = pos
    match dir:
        case "^":
            r -= 1
        case ">":
            c += 1
        case "v":
            r += 1
        case "<":
            c -= 1
    if 0 <= r < height and 0 <= c < width and A[r, c] != "":
        return r, c
    else:
        raise BadBoundsError()


def neighbors(
    A: np.ndarray, key: str
) -> Generator[tuple[str, tuple[int, int]], None, None]:
    pos = tuple(np.argwhere(A == key)[0])
    for dir in "^>v<":
        try:
            yield dir, A[forward(A, pos, dir)]
        except BadBoundsError:
            continue


class Controller(object):
    def cost(self, prev: str, cur: str):
        return 1


class Robot(Controller):
    controller: Controller
    pad: np.ndarray
    mem: dict[tuple[str, str], int]

    def __init__(self, controller: Controller, pad: np.ndarray):
        self.controller = controller
        self.pad = pad
        self.mem = {}

    def seq_cost(self, seq: str) -> int:
        seq = "A" + seq
        return sum(self.cost(prev, cur) for prev, cur in zip(seq[:-1], seq[1:]))

    def cost(self, prev: str, cur: str) -> int:
        # memoize
        if (prev, cur) in self.mem:
            return self.mem[prev, cur]
        # special case
        elif prev == cur:
            return self.controller.cost("A", "A")

        start = "A", prev
        end = "A", cur
        q = [(0, start)]

        checked = set()
        while len(q) > 0:
            cost, state = heappop(q)
            dir, key = state

            if state in checked:
                continue
            elif state == end:
                self.mem[prev, cur] = cost
                return cost

            checked.add(state)

            to_check = [("A", key)] + list(neighbors(self.pad, key))
            for d, k in to_check:
                heappush(q, (cost + self.controller.cost(dir, d), (d, k)))

        pass


me = Controller()
robot3 = Robot(me, D_PAD)
robot2 = Robot(robot3, D_PAD)
robot1 = Robot(robot2, NUM_PAD)

s = 0
for code in codes:
    s += int(code[:-1]) * robot1.seq_cost(code)

print(s)
