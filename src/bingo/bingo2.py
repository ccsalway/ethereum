import random

colcounter = [0 for _ in range(9)]


def add_column_count(row):
    for c in range(9):
        colcounter[c] += row[c]


def generate_row():
    row = [0 for _ in range(9)]
    while row.count(1) < 5:
        for c in range(9):
            row[c] = random.randint(0, 1)
            if row.count(1) == 5:
                break
    add_column_count(row)
    return row


def generate_ticket():
    tkt = [None for _ in range(3)]
    for r in range(3):
        tkt[r] = generate_row()
    return tkt


def generate_slip():
    slip = [None for _ in range(6)]
    for n in range(6):
        slip[n] = generate_ticket()
    return slip


if __name__ == '__main__':
    slip = generate_slip()
    for tkt in slip:
        for row in tkt:
            print(row.count(1), row)
        print(' ' * 10)
    
    print(sum(colcounter), colcounter)
