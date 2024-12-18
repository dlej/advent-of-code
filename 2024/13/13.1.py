import re

from pydantic import BaseModel


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
    det: int | None = None

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.det = self.a * self.d - self.b * self.c

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
for p in puzzles:
    # let's only bother with tricky stuff if we have to
    assert p.det != 0

    # solve the linear system
    pre_A = p.x * p.d - p.y * p.b
    pre_B = p.y * p.a - p.x * p.c
    # make sure there is an integer solution
    if pre_A % p.det == 0 and pre_B % p.det == 0:
        s += 3 * pre_A // p.det + pre_B // p.det


print(s)
