from collections import Counter, defaultdict
from dataclasses import dataclass


@dataclass
class Gate(object):
    in1: str
    in2: str
    out: str
    op: str

    def __repr__(self) -> str:
        return f"Gate({self.in1} {self.op} {self.in2} -> {self.out})"

    def __contains__(self, a: str) -> bool:
        return self.in1 == a or self.in2 == a


wires: set[str] = set()
gates: list[Gate] = []


reading_wires = True
with open("24.txt", "r") as f:
    for line in f.readlines():
        line = line.strip()
        if line == "":
            reading_wires = False
        elif reading_wires:
            label, value = line.split(":")
            wires.add(label)
        else:
            in1, op, in2, _, out = line.split(" ")
            gates.append(Gate(in1, in2, out, op))
            wires.add(out)


# should be a basic adder circuit with 44 full adders and 1 half-adder
# half adder = 1 AND, 1 XOR
# full adder = 2 AND, 1 OR, 2 XOR
gate_count = Counter(g.op for g in gates)
assert gate_count["AND"] == 1 + 44 * 2
assert gate_count["OR"] == 44
assert gate_count["XOR"] == 1 + 44 * 2


gates_by_input: dict[str, list[Gate]] = defaultdict(list)
gates_by_output: dict[str, Gate] = dict()
for gate in gates:
    gates_by_input[gate.in1].append(gate)
    gates_by_input[gate.in2].append(gate)
    gates_by_output[gate.out] = gate


# SWAPS ARE DONE BY HAND AND LOADED FROM THIS FILE
swaps = []
with open("24.swaps", "r") as f:
    for line in f.readlines():
        a, b = line.strip().split(",")
        ga = gates_by_output[a]
        gb = gates_by_output[b]
        ga.out = b
        gb.out = a
        gates_by_output[a] = gb
        gates_by_output[b] = ga
        swaps.extend([a, b])


# wire things up with mistakes fixed
for i in range(45):
    x = f"x{i:02d}"
    y = f"y{i:02d}"
    z = f"z{i:02d}"

    # every pair feeds only into two gates (AND and XOR) with each other
    assert sorted(g.op for g in gates_by_input[x]) == ["AND", "XOR"]
    assert sorted(g.op for g in gates_by_input[y]) == ["AND", "XOR"]
    assert gates_by_input[x] == gates_by_input[y]

    g_and, g_xor = sorted((g for g in gates_by_input[x]), key=lambda g: g.op)
    print(f">>{i=}>>")
    print(g_xor)
    print(g_and)

    # i = 0 is a special half adder case.
    # AND = carry
    # XOR = output
    if i == 0:
        assert g_xor.out == z
        carry = g_and.out
    else:
        # check that the circuit is a proper full adder
        carry_gates = sorted((g for g in gates_by_input[carry]), key=lambda g: g.op)
        assert [g.op for g in carry_gates] == ["AND", "XOR"]
        carry_and, carry_xor = carry_gates
        print(carry_xor)
        print(carry_and)
        assert g_xor.out in carry_xor
        assert g_xor.out in carry_and
        assert carry_xor.out == z
        g_and_gates = gates_by_input[g_and.out]
        assert [g.op for g in g_and_gates] == ["OR"]
        (g_or,) = g_and_gates
        print(g_or)
        carry = g_or.out

assert carry == "z45"

print(",".join(sorted(swaps)))
