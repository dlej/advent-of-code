from collections import defaultdict
from itertools import product

import numpy as np
from tqdm import tqdm

edges = defaultdict(set)

with open("23.txt", "r") as f:
    for line in f.readlines():
        a, b = line.strip().split("-")
        edges[a].add(a)
        edges[b].add(b)
        edges[a].add(b)
        edges[b].add(a)

ids_nodes = list(enumerate(edges))
node_id_map = {n: i for i, n in ids_nodes}
id_node_map = {i: n for i, n in ids_nodes}

A = np.zeros((len(edges), len(edges)))
for n, i in node_id_map.items():
    for m in edges[n]:
        A[i, node_id_map[m]] = 1


def is_k_clique(ids):
    B = A[ids, :][:, ids]
    return B.sum() == B.size


cliques = set()
for n in tqdm(edges):
    ids = np.asarray([node_id_map[m] for m in edges[n]])
    for mask in product(*[[False, True]] * len(ids)):
        masked_ids = ids[np.asarray(mask)]
        if len(masked_ids) > 2 and is_k_clique(masked_ids):
            cliques.add((",".join(sorted([id_node_map[i] for i in masked_ids]))))

print(max(cliques, key=len))
