import numpy as np

X = np.loadtxt("1.txt", delimiter=" ", dtype=object)
x1 = np.sort(X[:, 0].astype(int))
x2 = np.sort(X[:, -1].astype(int))

print(sum(abs(x1 - x2)))
