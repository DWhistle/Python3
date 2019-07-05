trash = input()
mass = [int(m) for m in input().split()]

d = {}
max_occ = 0
maximum = 0
for i in sorted(mass):
    if not i in d.keys():
        d[i] = 1
    else:
        d[i] += 1
for key, val in d.items():
    if val >= max_occ:
        max_occ = val
        maximum = key
print(maximum)



