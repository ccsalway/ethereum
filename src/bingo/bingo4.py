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
for tkts in slip:
    for row in tkts:
        rows.append(row)
for row in rows:
    print(row)


for tkt in slip:
    for row in tkt:
        print(row.count(1), row)
    print(' ' * 10)