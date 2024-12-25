from functools import partial

import numpy as np

locks = []
keys = []

with open("25.txt", "r") as f:
    for chunk in iter(partial(f.read, 43), ""):
        data = np.asarray([c for c in chunk[:42]], dtype=object).reshape(7, 6)[:, :5]
        data = data == "#"
        if data[0, :].sum() == 5:
            locks.append(data.sum(0))
        else:
            keys.append(data.sum(0))

locks = np.asarray(locks)
keys = np.asarray(keys)

print(np.sum((locks[:, None, :] + keys[None, :, :] <= 7).sum(-1) == 5))
