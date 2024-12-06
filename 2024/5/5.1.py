from collections import defaultdict

with open("5.txt", "r") as f:
    lines = f.readlines()


ordering = defaultdict(set)

doing_ordering = True
s = 0

for line in lines:
    line = line.strip()

    if line == "":
        doing_ordering = False
        continue

    if doing_ordering:
        x, y = line.split("|")
        ordering[x].add(y)
    else:
        pages = line.split(",")
        in_order = True
        for i in range(len(pages)):
            for j in range(i + 1, len(pages)):
                if pages[j] not in ordering[pages[i]]:
                    in_order = False
                    break
            if not in_order:
                break
        if in_order:
            s += int(pages[len(pages) // 2])

print(s)
