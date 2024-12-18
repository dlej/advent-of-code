import re


class Computer(object):
    a: int = 0
    b: int = 0
    c: int = 0
    pc: int = 0
    program: list[int] | None = None
    output: list[int] | None = None

    def run(
        self,
        program: list[int],
        a: int | None = None,
        b: int | None = None,
        c: int | None = None,
    ) -> list[int]:
        if a is not None:
            self.a = a
        if b is not None:
            self.b = b
        if c is not None:
            self.c = c
        self.program = program
        self.output = []

        try:
            while True:
                opcode, operand = program[self.pc], program[self.pc + 1]
                self.instruction_map(opcode)(operand)
        except IndexError:
            return self.output

    # Instructions
    def adv(self, operand: int):
        self.a //= 2 ** self.combo_map(operand)
        self.pc += 2

    def bxl(self, operand: int):
        self.b ^= operand
        self.pc += 2

    def bst(self, operand: int):
        self.b = self.combo_map(operand) % 8
        self.pc += 2

    def jnz(self, operand: int):
        if self.a == 0:
            self.pc += 2
        else:
            self.pc = operand

    def bxc(self, operand: int):
        self.b ^= self.c
        self.pc += 2

    def out(self, operand: int):
        self.output.append(self.combo_map(operand) % 8)
        self.pc += 2

    def bdv(self, operand: int):
        self.b = self.a // 2 ** self.combo_map(operand)
        self.pc += 2

    def cdv(self, operand: int):
        self.c = self.a // 2 ** self.combo_map(operand)
        self.pc += 2

    def instruction_map(self, opcode: int):
        match opcode:
            case 0:
                return self.adv
            case 1:
                return self.bxl
            case 2:
                return self.bst
            case 3:
                return self.jnz
            case 4:
                return self.bxc
            case 5:
                return self.out
            case 6:
                return self.bdv
            case 7:
                return self.cdv

    def combo_map(self, operand: int):
        match operand:
            case 4:
                return self.a
            case 5:
                return self.b
            case 6:
                return self.c
            case 7:
                raise ValueError("Invalid combo operand 7")
            case _:
                return operand

    def __repr__(self):
        return f"A={self.a},B={self.b},C={self.c}"


with open("17.txt", "r") as f:
    a = int(re.match(r"Register A: (\d+)", f.readline())[1])
    b = int(re.match(r"Register B: (\d+)", f.readline())[1])
    c = int(re.match(r"Register C: (\d+)", f.readline())[1])
    f.readline()
    program = [int(x) for x in f.readline().split(" ")[1].strip().split(",")]

comp = Computer()
output = comp.run(program, a=a, b=b, c=c)

print(",".join(str(x) for x in output))
