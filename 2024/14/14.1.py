from functools import reduce
from operator import mul
import re

from pydantic import BaseModel

pattern = re.compile(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)")

# fn, width, height = "14.test", 11, 7
fn, width, height = "14.txt", 101, 103


class Robot(BaseModel):
    px: int
    py: int
    vx: int
    vy: int


robots = []
with open(fn, "r") as f:
    for px, py, vx, vy in pattern.findall(f.read()):
        robots.append(Robot(px=px, py=py, vx=vx, vy=vy))

midx = width // 2
midy = height // 2

quadrants = [0] * 4
seconds = 100

for robot in robots:
    px = (robot.px + seconds * robot.vx) % width
    py = (robot.py + seconds * robot.vy) % height
    if px == midx or py == midy:
        continue
    quadrants[2 * (px // (midx + 1)) + py // (midy + 1)] += 1

print(reduce(mul, quadrants, 1))
