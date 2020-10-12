#!python3

import sys

# Loop over standard in
skipFirstFewLines = True
for line in map(str.rstrip, sys.stdin):

    if skipFirstFewLines:
        # Continue until we find the line starting
        if "A star (*) next to a name means that the command is disabled." in line:
            skipFirstFewLines = False
        continue

    tokens = line.split()
    firstCommand = tokens[0]



    for x in tokens:
        print(x, end=' ')
    print('========')
