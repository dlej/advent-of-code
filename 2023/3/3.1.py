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


class Schematic(object):
    def __init__(self, lines):
        self.arr = np.asarray([str_to_np(s) for s in lines])
        self.padded_arr = np.pad(self.arr, [(1, 1), (1, 1)], constant_values=".")
        self.number_matches = self.find_all_numbers()
        self.parts = self.filter_numbers_for_parts(self.number_matches)

    def find_all_numbers(self):
        pos_length_num = []
        for i, line in enumerate(self.arr):
            line = np_to_str(line)
            for match in re.finditer(r"\d+", line):
                j1, j2 = match.span()
                length = j2 - j1
                pos_length_num.append(NumberMatch((i, j1), length, int(match[0])))
        return pos_length_num

    def get_number_periphery(self, match):
        i, j = match.pos
        top = self.padded_arr[i : i + 1, j : j + match.length + 2]
        left = self.padded_arr[i + 1, j : j + 1]
        right = self.padded_arr[i + 1, j + match.length + 1 : j + match.length + 2]
        bottom = self.padded_arr[i + 2 : i + 3, j : j + match.length + 2]
        return np.concatenate([top.ravel(), right, bottom.ravel(), left])

    def filter_numbers_for_parts(self, number_matches):
        parts = []
        for match in number_matches:
            periphery = self.get_number_periphery(match)
            if np.any(periphery != "."):
                parts.append(match)
        return parts

    def ravel(self):
        return self.arr.ravel()

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
print(sum(part.num for part in sch.parts))
