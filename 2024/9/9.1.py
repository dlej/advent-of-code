with open("9.txt", "r") as f:
    line = f.readline().strip()

line = [c for c in line]
expansion = [0] * int(line.pop(0))
id = 1
while len(line) > 0:
    spaces, blocks = int(line.pop(0)), int(line.pop(0))
    expansion += [-1] * spaces
    expansion += [id] * blocks
    id += 1

space_pos = [i for i, v in enumerate(expansion) if v == -1]
block_pos = [i for i, v in enumerate(expansion) if v != -1]

for i, j in zip(space_pos, block_pos[::-1]):
    if i >= j:
        break
    expansion[i] = expansion[j]
    expansion[j] = -1

print(sum(i * v for i, v in enumerate(expansion) if v != -1))
