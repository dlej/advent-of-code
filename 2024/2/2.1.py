import numpy as np


def is_safe(report):
    increasing = all(report == np.sort(report))
    decreasing = all(report == np.sort(report)[::-1])
    diff = np.abs(np.diff(report))
    gradual = all(diff >= 1) and all(diff <= 3)

    return (increasing or decreasing) and gradual


with open("2.txt", "r") as f:
    reports = [
        np.asarray([int(x) for x in line.strip().split(" ")]) for line in f.readlines()
    ]
print(sum(is_safe(report) for report in reports))
