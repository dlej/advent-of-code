import re

with open("3.txt", "r") as f:
    txt = f.read()

s = 0
on = True
for m in re.finditer(r"mul\((\d+),(\d+)?\)", txt):
    s += int(m[1]) * int(m[2])

print(s)
