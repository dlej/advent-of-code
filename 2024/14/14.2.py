import re

import numpy as np
from pydantic import BaseModel
from scipy.stats import entropy

pattern = re.compile(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)")

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

# find phase for x and y (where the robots localize to a small band in each direction)
entropies_x = np.zeros(width)
entropies_y = np.zeros(height)

for i in range(width):
    nx = np.zeros(width)
    for robot in robots:
        nx[(robot.px + i * robot.vx) % width] += 1
    entropies_x[i] = entropy(nx / nx.sum())
phase_x = np.argmin(entropies_x)

for j in range(height):
    ny = np.zeros(height)
    for robot in robots:
        ny[(robot.py + j * robot.vy) % height] += 1
    entropies_y[j] = entropy(ny / ny.sum())
phase_y = np.argmin(entropies_y)

# find where they match up after enough cycles:
s_x = phase_x
s_y = phase_y
while s_x != s_y:
    if s_x < s_y:
        s_x += width
    else:
        s_y += height

print(s_x)
