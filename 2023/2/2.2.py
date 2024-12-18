from collections import defaultdict
from functools import reduce
from operator import mul


def get_game_powers(lines):
    for line in lines:
        reveals = line.split(":")[-1]
        nums = defaultdict(int)
        for reveal in reveals.split(";"):
            for cubes in reveal.split(","):
                num, color = cubes.strip().split(" ")
                nums[color] = max(nums[color], int(num))
        yield reduce(mul, nums.values(), 1)


with open("2.txt", "r") as f:
    lines = f.readlines()

print(sum(get_game_powers(lines)))
