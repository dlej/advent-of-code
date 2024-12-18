from dataclasses import dataclass
import re

import numpy as np


def str_to_np(s):
    return np.asarray([c for c in s], dtype=str)


def np_to_str(arr):
    return "".join(arr)


@dataclass
class NumberMatch:
    pos: tuple[int]
    length: int
    num: int


def is_next_to(match, i, j):
    i_condition = match.pos[0] - 1 <= i <= match.pos[0] + 1
    j_condition = match.pos[1] - 1 <= j <= match.pos[1] + match.length
    return i_condition and j_condition


class Schematic(object):
    def __init__(self, lines):
        self.arr = np.asarray([str_to_np(s) for s in lines])
        self.number_matches = self.find_all_numbers()
        self.gear_ratios = self.find_all_gear_ratios()

    def find_all_numbers(self):
        pos_length_num = []
        for i, line in enumerate(self.arr):
            line = np_to_str(line)
            for match in re.finditer(r"\d+", line):
                j1, j2 = match.span()
                length = j2 - j1
                pos_length_num.append(NumberMatch((i, j1), length, int(match[0])))
        return pos_length_num

    def find_all_gear_ratios(self):
        gear_ratios = []
        where_asterisks = np.argwhere(self.arr == "*")
        for i, j in where_asterisks:
            parts = [match for match in self.number_matches if is_next_to(match, i, j)]
            if len(parts) == 2:
                gear_ratios.append(parts[0].num * parts[1].num)
        return gear_ratios

    def __getitem__(self, idx):
        sub_arr = self.arr[idx]
        match sub_arr.ndim:
            case 0:
                return sub_arr.item()
            case 1:
                return self.__class__([sub_arr])
            case 2:
                return self.__class__(sub_arr)

    def __str__(self):
        return "\n".join(["".join(c for c in line) for line in self.arr])

    def __repr__(self):
        return str(self)

    @classmethod
    def load(cls, filename):
        with open(filename, "r") as f:
            lines = f.readlines()
        lines = [line.strip() for line in lines]
        return cls(lines)


sch = Schematic.load("3.txt")
print(sum(sch.gear_ratios))
