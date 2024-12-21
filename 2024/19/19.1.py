import re

s = 0
with open("19.txt", "r") as f:
    towels = re.findall(r"\w+", f.readline())
    f.readline()
    towel_re = re.compile(rf"^({"|".join(towels)})+$")
    for line in f.readlines():
        if towel_re.match(line.strip()) is not None:
            s += 1

print(s)
