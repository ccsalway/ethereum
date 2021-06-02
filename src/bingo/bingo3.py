import random

slip = [[[0 for _ in range(9)] for _ in range(3)] for _ in range(6)]


for tkt in slip:
    rows = [0, 1, 2]
    for c in range(9):
        r = random.choice(rows)
        tkt[r][c] = 1
        if tkt[r].count(1) == 5:
            rows.remove(r)

rows = []
for tkt in slip:
    for row in tkt:
        rows.append(row)

for c in range(9):
    avail = 4
    while avail > 0:
        row = random.choice(rows)
        if row.count(1) == 5:
            continue
        if row[c] == 1:
            continue
        row[c] = 1
        avail -= 1


for tkt in slip:
    for row in tkt:
        print(row.count(1), row)
    print(' ' * 10)

colcounter = [0 for _ in range(9)]
for tkt in slip:
    for row in tkt:
        for c in range(9):
            colcounter[c] += row[c]

print(sum(colcounter), colcounter)
