import numpy as np


def is_safe(report, allow_remove=True):
    increasing = all(report == np.sort(report))
    decreasing = all(report == np.sort(report)[::-1])
    diff = np.abs(np.diff(report))
    gradual = all(diff >= 1) and all(diff <= 3)

    if (increasing or decreasing) and gradual:
        return True
    elif allow_remove:
        for i in range(len(report)):
            sub_report = np.concatenate([report[:i], report[i + 1 :]])
            if is_safe(sub_report, allow_remove=False):
                return True
    return False


with open("2.txt", "r") as f:
    reports = [
        np.asarray([int(x) for x in line.strip().split(" ")]) for line in f.readlines()
    ]
print(sum(is_safe(report) for report in reports))
