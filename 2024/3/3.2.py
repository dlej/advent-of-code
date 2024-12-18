import re

with open("3.txt", "r") as f:
    txt = f.read()

s = 0
on = True
for m in re.finditer(r"(do|don't|mul)\(((\d+),(\d+))?\)", txt):
    if m[1] == "do":
        on = True
    elif m[1] == "don't":
        on = False
    if m[1] == "mul" and on:
        s += int(m[3]) * int(m[4])

print(s)
