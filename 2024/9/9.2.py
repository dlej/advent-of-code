with open("9.txt", "r") as f:
    line = f.readline().strip()

line = [c for c in line]
expansion = [0] * int(line.pop(0))
empty_spaces = []
files = []
id = 1
while len(line) > 0:
    spaces, blocks = int(line.pop(0)), int(line.pop(0))
    empty_spaces.append((len(expansion), spaces))
    expansion += [-1] * spaces
    files.append((len(expansion), blocks))
    expansion += [id] * blocks
    id += 1

for pos, blocks in files[::-1]:
    try:
        i = next(
            iter(
                i
                for i, (j, length) in enumerate(empty_spaces)
                if j < pos and length >= blocks
            )
        )
    except StopIteration:
        continue

    j, length = empty_spaces[i]
    expansion[j : j + blocks] = [expansion[pos]] * blocks
    expansion[pos : pos + blocks] = [-1] * blocks
    if length == blocks:
        empty_spaces.pop(i)
    else:
        empty_spaces[i] = j + blocks, length - blocks

print(sum(i * v for i, v in enumerate(expansion) if v != -1))
