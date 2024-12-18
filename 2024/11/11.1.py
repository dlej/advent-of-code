with open("11.txt", "r") as f:
    stones = f.readline().strip().split(" ")

blinks = 25

for _ in range(blinks):
    new_stones = []
    for stone in stones:
        n = len(stone)
        if stone == "0":
            new_stones.append("1")
        elif n % 2 == 0:
            new_stones.append(stone[: n // 2])
            new_stones.append(str(int(stone[n // 2 :])))
        else:
            new_stones.append(str(2024 * int(stone)))
    stones = new_stones

print(len(stones))
