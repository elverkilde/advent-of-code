import sys
import string

f = open(sys.argv[1])

program = map(lambda x: int(x), string.split(f.read(), ","))

def interpret(i, prg):
    if prg[i] == 99:
        return prg
    if prg[i] == 1:
        prg[prg[i+3]] = prg[prg[i+1]] + prg[prg[i+2]]
    elif prg[i] == 2:
        prg[prg[i+3]] = prg[prg[i+1]] * prg[prg[i+2]]
    return interpret(i+4, prg)

for noun in range(0,100):
    for verb in range(0,100):
        copy = list(program)
        copy[1] = noun
        copy[2] = verb
        if interpret(0, copy)[0] == 19690720:
            print (noun, verb)
            print 100 * noun + verb
