from collections import defaultdict
from dataclasses import dataclass
from typing import Generator

import numpy as np
from pydantic import BaseModel


class Dir(BaseModel):
    expansion: list[int]
    marker: str

    def __sub__(self, other: "Dir") -> int:
        return sum(abs(a - b) for a, b in zip(self.expansion, other.expansion))

    def __hash__(self) -> str:
        return hash(f"{self.expansion}{self.marker}")


class D(object):
    NORTH = Dir(expansion=[0, 0], marker="^")
    EAST = Dir(expansion=[0, 1], marker=">")
    SOUTH = Dir(expansion=[1, 1], marker="v")
    WEST = Dir(expansion=[1, 0], marker="<")


WALL = ord("#")


A = np.fromfile("16.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]

START = tuple(np.argwhere(A == ord("S"))[0])
END = tuple(np.argwhere(A == ord("E"))[0])

traversed = {}


DIRS = [D.NORTH, D.EAST, D.SOUTH, D.WEST]


def forward(pos: tuple[int], dir: Dir) -> tuple[int]:
    r, c = pos
    match dir:
        case D.NORTH:
            return r - 1, c
        case D.EAST:
            return r, c + 1
        case D.SOUTH:
            return r + 1, c
        case D.WEST:
            return r, c - 1


@dataclass(frozen=True)
class Node(object):
    pos: tuple[int]
    dir: Dir


class MazeAStar(object):
    def __init__(self, A: np.ndarray):
        self.A = A
        self.height, self.width = A.shape
        self.start = tuple(np.argwhere(A == ord("S"))[0])
        self.end = tuple(np.argwhere(A == ord("E"))[0])

    def solve_all(self) -> list[list[Node]]:
        candidates = []
        paths = [[Node(pos=self.start, dir=D.EAST)]]
        dest = Node(pos=self.end, dir=D.NORTH)
        best_costs = defaultdict(lambda: np.inf)
        best_costs[paths[0][0]] = 0
        best_cost = np.inf

        while len(paths) > 0:
            path = paths.pop(0)
            last = path[-1]
            last_cost = best_costs[last]
            if self.is_goal_reached(last, dest):
                candidates.append(path)
                best_cost = min(best_cost, last_cost)
                continue
            for n in self.neighbors(last):
                cost = last_cost + self.distance_between(last, n)
                if best_costs[n] < cost:
                    continue
                best_costs[n] = cost
                paths.append(path + [n])

        return [soln for soln in candidates if self.cost(soln) == best_cost]

    def cost(self, nodes: list[Node]) -> int:
        return sum(
            self.distance_between(n1, n2) for n1, n2 in zip(nodes[:-1], nodes[1:])
        )

    def neighbors(self, node: Node) -> Generator[Node, None, None]:
        for dir in DIRS:
            if dir == node.dir:
                if self.A[step := forward(node.pos, dir)] != WALL:
                    yield Node(step, dir)
            else:
                yield Node(node.pos, dir)

    def distance_between(self, n1: Node, n2: Node) -> int:
        return sum(abs(x - y) for x, y in zip(n1.pos, n2.pos)) + 1000 * (
            n1.dir - n2.dir
        )

    def is_goal_reached(self, current: Node, goal: Node):
        return current.pos == goal.pos


def print_maze(A: np.ndarray, soln: list[Node]) -> None:
    B = A.copy()
    for node in soln:
        B[node.pos] = ord(node.dir.marker)
    height, width = A.shape
    for r in range(height):
        for c in range(width):
            s = chr(B[r, c])
            print(s, end="")
        print("")


maze_astar = MazeAStar(A)
solns = maze_astar.solve_all()

for soln in solns:
    for node in soln:
        A[node.pos] = ord("O")

print(np.sum(A == ord("O")))
