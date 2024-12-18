from collections import OrderedDict
import os

digit_strings = {str(i): i for i in range(10)}
digit_strings.update(
    {
        "zero": 0,
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9,
    }
)


def find_all_digits(s):
    for i in range(len(s)):
        substr = s[i : i + 5]
        for d, v in digit_strings.items():
            if substr.startswith(d):
                yield v
                break


with open(os.path.join("1.txt"), "r") as f:
    lines = f.readlines()


print(
    sum(
        integers[0] * 10 + integers[-1]
        for integers in [list(find_all_digits(line)) for line in lines]
    )
)
