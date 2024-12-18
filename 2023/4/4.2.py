from dataclasses import dataclass
from functools import cached_property
import re


@dataclass
class Card(object):
    id: int
    winning: set[int]
    numbers: set[int]

    @cached_property
    def matches(self):
        return len(self.winning & self.numbers)

    def __hash__(self):
        return hash(self.id)

    @classmethod
    def from_line(cls, line):
        card_info, rest = line.split(":")
        winning, numbers = rest.split("|")

        id = int(card_info.split(" ")[-1])
        winning = {int(num) for num in re.findall(r"\d+", winning)}
        numbers = {int(num) for num in re.findall(r"\d+", numbers)}

        return cls(id, winning, numbers)


with open("4.txt", "r") as f:
    cards = [Card.from_line(line) for line in f.readlines()]

counts = [1] * len(cards)

for i, card in enumerate(cards):
    for j in range(i + 1, i + card.matches + 1):
        counts[j] += counts[i]

print(sum(counts))
