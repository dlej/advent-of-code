from collections import defaultdict

edges = defaultdict(set)

with open("23.txt", "r") as f:
    for line in f.readlines():
        a, b = line.strip().split("-")
        edges[a].add(b)
        edges[b].add(a)

triangles = set()
for a in edges:
    for b in edges[a]:
        for c in edges[b]:
            if a in edges[c] and any(x.startswith("t") for x in [a, b, c]):
                triangles.add(",".join(sorted([a, b, c])))

print(len(triangles))
