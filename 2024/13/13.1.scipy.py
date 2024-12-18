import re

import numpy as np
from pydantic import BaseModel
from scipy.optimize import LinearConstraint, milp
from tqdm import tqdm


pattern = re.compile(
    r"""
Button A: X\+(\d+), Y\+(\d+)
Button B: X\+(\d+), Y\+(\d+)
Prize: X=(\d+), Y=(\d+)
""".strip("\n")
)


class Puzzle(BaseModel):
    a: int
    b: int
    c: int
    d: int
    x: int
    y: int

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_linear_constraint(self):
        A = np.asarray([[self.a, self.b], [self.c, self.d]])
        b = np.asarray([self.x, self.y])
        return LinearConstraint(A, b, b)

    @classmethod
    def parse_file(cls, f_read):
        puzzles = []
        for m in pattern.finditer(f_read):
            puzzles.append(
                cls.model_validate(
                    {"a": m[1], "b": m[3], "c": m[2], "d": m[4], "x": m[5], "y": m[6]}
                )
            )

        return puzzles


with open("13.txt", "r") as f:
    puzzles = Puzzle.parse_file(f.read())


s = 0
# fun to do this as a MILP, but unfortunately working with double
# precision isn't enough digits for part 2...
cost = np.asarray([3, 1])
for p in tqdm(puzzles):
    res = milp(
        cost,
        integrality=3,
        constraints=p.get_linear_constraint(),
    )
    if res.x is not None:
        s += res.x.astype(int) @ cost

print(s)
