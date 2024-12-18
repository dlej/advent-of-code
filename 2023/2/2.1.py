MAXIMUMS = {"red": 12, "green": 13, "blue": 14}


def is_valid(reveals):
    for reveal in reveals.split(";"):
        for cubes in reveal.split(","):
            num, color = cubes.strip().split(" ")
            num = int(num)
            if num > MAXIMUMS[color]:
                return False
    return True


def get_valid_games(lines):
    for line in lines:
        game_id, reveals = line.split(":")
        game_id = int(game_id.split(" ")[-1])
        if is_valid(reveals):
            yield game_id


with open("2.txt", "r") as f:
    lines = f.readlines()

print(sum(get_valid_games(lines)))
