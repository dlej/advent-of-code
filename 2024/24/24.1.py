from collections import defaultdict
from dataclasses import dataclass
from operator import and_, or_, xor
from typing import Callable


@dataclass
class Gate(object):
    in1: str
    in2: str
    out: str
    op: Callable[[bool, bool], bool]


op_map = {"AND": and_, "OR": or_, "XOR": xor}

wires: dict[str, bool] = defaultdict(lambda: None)
gates: list[Gate] = []


reading_wires = True
with open("24.txt", "r") as f:
    for line in f.readlines():
        line = line.strip()
        if line == "":
            reading_wires = False
        elif reading_wires:
            label, value = line.split(":")
            wires[label] = value == " 1"
        else:
            in1, op, in2, _, out = line.split(" ")
            gates.append(Gate(in1, in2, out, op_map[op]))
            wires[out]


while any(x is None for x in wires.values()):
    for gate in gates:
        if (
            wires[gate.out] is None
            and wires[gate.in1] is not None
            and wires[gate.in2] is not None
        ):
            wires[gate.out] = gate.op(wires[gate.in1], wires[gate.in2])

z_labels = [x for x in wires if x.startswith("z")]
s = 0
for i in range(len(z_labels)):
    s += 2**i if wires[f"z{i:02d}"] else 0

print(s)
