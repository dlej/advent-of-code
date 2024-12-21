import re


s = 0
with open("19.txt", "r") as f:
    towels = re.findall(r"\w+", f.readline())
    f.readline()
    towel_re = re.compile(rf"^({"|".join(towels)})+$")
    designs = [line.strip() for line in f.readlines()]


mem = {}


def recursive_count(tail):
    if tail in mem:
        return mem[tail]
    s = 0
    for towel in towels:
        if tail == towel:
            s += 1
        if tail.startswith(towel):
            s += recursive_count(tail[len(towel) :])
    mem[tail] = s
    return s


print(sum(recursive_count(design) for design in designs))
