from dataclasses import dataclass
from functools import cached_property
import re


@dataclass
class Card(object):
    id: int
    winning: set[int]
    numbers: set[int]

    @cached_property
    def points(self):
        return int(2 ** (len(self.winning & self.numbers) - 1))

    @classmethod
    def from_line(cls, line):
        card_info, rest = line.split(":")
        winning, numbers = rest.split("|")

        id = int(card_info.split(" ")[-1])
        winning = {int(num) for num in re.findall(r"\d+", winning)}
        numbers = {int(num) for num in re.findall(r"\d+", numbers)}

        return cls(id, winning, numbers)


with open("4.txt", "r") as f:
    print(sum(Card.from_line(line).points for line in f.readlines()))
