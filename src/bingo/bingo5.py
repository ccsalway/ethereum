import random


pool = [list(range(1 + 10*x, 11 + 10*x)) for x in range(9)]


def get_random_number(col):
    n = random.choice(pool[col])
    pool[col].remove(n)
    return n


def generate_ticket():
    tkt = [[0 for _ in range(9)] for _ in range(3)]
    # populate a 1 in each column
    rows = [0, 1, 2]
    for c in range(9):
        r = random.choice(rows)
        tkt[r][c] = 1
        if tkt[r].count(1) == 5:
            rows.remove(r)
    # make up the rest of the row
    for row in tkt:
        cols = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        while row.count(1) < 5:
            c = random.choice(cols)
            row[c] = 1
            cols.remove(c)
    # populate numbers
    for c in range(9):
        ttlnums = tkt[0][c] + tkt[1][c] + tkt[2][c]
        rndnums = sorted([get_random_number(c) for _ in range(ttlnums)])
        for r in [2, 1, 0]:
            if tkt[r][c] == 1:
                tkt[r][c] = rndnums.pop()
    # return
    return tkt


if __name__ == '__main__':
    tkt = generate_ticket()
    print(tkt)
    for row in tkt:
        print(row)
