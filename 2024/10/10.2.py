import numpy as np

A = np.fromfile("10.txt", dtype=np.ubyte)
width = np.argwhere(A == 10)[0, 0]
A = A.reshape((-1, width + 1))[:, :width]
height = A.shape[0]

trailheads = np.argwhere(A == ord("0"))


def is_in_bounds(r, c):
    return 0 <= r < height and 0 <= c < width


scores = []
for r, c in trailheads:
    score = 0
    queue = [(0, r, c)]
    while len(queue) > 0:
        depth, r, c = queue.pop(0)
        if depth == 9:
            score += 1
            continue
        for r_, c_ in [(r - 1, c), (r, c + 1), (r + 1, c), (r, c - 1)]:
            to_check = (depth + 1, r_, c_)
            if is_in_bounds(r_, c_) and A[r_, c_] == A[r, c] + 1:
                queue.append(to_check)
    scores.append(score)

print(sum(scores))
