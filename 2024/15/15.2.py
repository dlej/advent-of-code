boxes = {}


class Box(object):
    def __init__(self, pos):
        r, c = pos
        boxes[pos] = self
        boxes[(r, c + 1)] = self
        self.pos = pos

    def update_pos(self, pos):
        r, c = self.pos
        del boxes[self.pos]
        del boxes[(r, c + 1)]

        r, c = pos
        boxes[pos] = self
        boxes[(r, c + 1)] = self
        self.pos = pos

    def get_chr(self, pos):
        r, c = pos
        if pos == self.pos:
            return "["
        elif (r, c - 1) == self.pos:
            return "]"
        else:
            raise ValueError("Box is not located at position")

    def move(self, dir, dry_run=True):
        r, c = self.pos
        match dir:
            case "^":
                spaces = [(r - 1, c), (r - 1, c + 1)]
                step = r - 1, c
            case ">":
                spaces = [(r, c + 2)]
                step = r, c + 1
            case "v":
                spaces = [(r + 1, c), (r + 1, c + 1)]
                step = r + 1, c
            case "<":
                spaces = [(r, c - 1)]
                step = r, c - 1

        for space in spaces:
            if space in walls:
                return False
            if (box := boxes.get(space, None)) is not None and not box.move(
                dir, dry_run=dry_run
            ):
                return False

        # otherwise, move the box
        if not dry_run:
            self.update_pos(step)
        return True


map_str = ""
directions = []
height = 0

with open("15.txt", "r") as f:
    reading_map = True
    for line in f.readlines():
        line = line.strip()
        if line == "":
            reading_map = False
        if reading_map:
            map_str += line
            width = len(line)
            height += 1
        else:
            directions.extend([c for c in line])


walls = set()

for i, x in enumerate(map_str):
    r, c = divmod(i, width)
    match x:
        case "#":
            walls.add((r, 2 * c))
            walls.add((r, 2 * c + 1))
        case "O":
            Box((r, 2 * c))
        case "@":
            robot = r, 2 * c

width *= 2


def print_map():
    for r in range(height):
        for c in range(width):
            pos = r, c
            if pos in walls:
                mark = "#"
            elif (box := boxes.get(pos, None)) is not None:
                mark = box.get_chr(pos)
            elif pos == robot:
                mark = "@"
            else:
                mark = "."
            print(mark, end="")
        print("")


for dir in directions:
    r, c = robot
    match dir:
        case "^":
            check_pos = r - 1, c
        case ">":
            check_pos = r, c + 1
        case "v":
            check_pos = r + 1, c
        case "<":
            check_pos = r, c - 1

    if check_pos in walls:
        continue
    elif (box := boxes.get(check_pos, None)) is not None:
        if box.move(dir, dry_run=True):
            box.move(dir, dry_run=False)
        else:
            continue

    robot = check_pos

# since we store both left and right, we double count
print(sum(100 * b.pos[0] + b.pos[1] for b in boxes.values()) // 2)
