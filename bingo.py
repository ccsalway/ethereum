import random

# there is an edge case where a card isnt filled out and hits the iterative limit
while 1:

    seqs = [
        list(range(1, 10 + 1)),
        list(range(11, 20 + 1)),
        list(range(21, 30 + 1)),
        list(range(31, 40 + 1)),
        list(range(41, 50 + 1)),
        list(range(51, 60 + 1)),
        list(range(61, 70 + 1)),
        list(range(71, 80 + 1)),
        list(range(81, 90 + 1))
    ]

    cards = [[{'col': c, 'vals': []} for c in range(9)] for _ in range(6)]

    # add at least one number to each column
    for card in cards:
        for c in range(len(card)):
            # randomly select a number
            n = random.choice(seqs[c])
            # remove that number from further selection
            seqs[c].remove(n)
            # place the number in the relevant column
            card[c]['vals'].append(n)

    # distribute remaining numbers across cards
    limit = 0
    while limit < 1000:
        # ensure no card has more than 15 numbers
        unfilled = [card for card in cards if sum([len(col['vals']) for col in card]) < 15]
        for card in unfilled:
            # filter out sequences with no values
            avail = [(idx, vals) for idx, vals in enumerate(seqs) if len(vals) > 0]
            if not avail: break
            # select a random column to assign a number
            idx, vals = random.choice(avail)
            # ensure column doesnt already have 3 numbers
            if len(card[idx]['vals']) == 3:
                continue
            # randomly select a number
            n = random.choice(vals)
            # remove the chosen number from further selection
            seqs[idx].remove(n)
            # place the number in the relevant column
            card[idx]['vals'].append(n)
        # end loop if no more numbers available
        if not unfilled: break
        if not avail: break
        limit += 1

    if limit < 1000:
        break

# organise columns into rows
for card in cards:

    rows = [[' ' for _ in range(9)] for _ in range(3)]

    # sort seqs into rows of no more than 5 numbers
    for s in [3, 2, 1]:
        fcols = [c for c in card if len(c['vals']) == s]
        for col in fcols:
            # loop over each value and assign to a row
            r = random.randrange(3)
            for i in range(s):
                # ensure we add to a row with space
                while rows[r].count(' ') <= 4 or rows[r][col['col']] != ' ':
                    r += 1
                    if r > 2:
                        r = 0
                # add value to row,column
                rows[r][col['col']] = col['vals'][i]

    # print rows
    for row in rows:
        print(row)
    
    print(' ' * 20)
