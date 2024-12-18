from collections import defaultdict

stones = defaultdict(lambda: 0)
with open("11.txt", "r") as f:
    for stone in f.readline().strip().split(" "):
        stones[stone] += 1

blinks = 75


for _ in range(blinks):
    new_stones = defaultdict(lambda: 0)
    for stone, quantity in stones.items():
        n = len(stone)
        to_add = []
        if stone == "0":
            to_add.append("1")
        elif n % 2 == 0:
            to_add.append(stone[: n // 2])
            to_add.append(str(int(stone[n // 2 :])))
        else:
            to_add.append(str(2024 * int(stone)))
        for s in to_add:
            new_stones[s] += quantity
    stones = new_stones

print(sum(stones.values()))
