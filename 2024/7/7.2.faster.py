from operator import add, mul


with open("7.txt", "r") as f:
    lines = f.readlines()

equations = []
for line in lines:
    test_value, nums = line.split(":")
    test_value = int(test_value)
    nums = [int(x) for x in nums.strip().split(" ")]
    equations.append((test_value, nums))


def concat(a, b):
    return int(str(a) + str(b))


def process(equation):
    test_value, nums = equation
    partials = [nums.pop(0)]
    for num in nums:
        next_partials = []
        for partial in partials:
            for op in [add, mul, concat]:
                s = op(partial, num)
                if s <= test_value:
                    next_partials.append(s)
        partials = next_partials
    if any(x == test_value for x in partials):
        return test_value
    else:
        return 0


print(sum(process(eq) for eq in equations))
