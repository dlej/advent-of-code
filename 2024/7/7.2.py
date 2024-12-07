from itertools import product
from operator import add, mul
from tqdm import tqdm


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


def eval_ops(nums, ops):
    nums = list(nums)
    s = nums.pop(0)
    for op, num in zip(ops, nums):
        s = op(s, num)
    return s


s = 0
for test_value, nums in tqdm(equations):
    for ops in product(*[[add, mul, concat]] * (len(nums) - 1)):
        if test_value == eval_ops(nums, ops):
            s += test_value
            break

print(s)
