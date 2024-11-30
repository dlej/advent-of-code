with open("1.txt", "r") as f:
    lines = f.readlines()


def get_integers(line):
    for s in line:
        try:
            yield int(s)
        except:
            pass


print(
    sum(
        integers[0] * 10 + integers[-1]
        for integers in [list(get_integers(line)) for line in lines]
    )
)
