length = input()
to_check = input()
occ = input ()

d = {}

it = 0
pool = []
while it < length:
    ip = input()
    if ip not in d:
        d[ip] = [[0] * 2]
    else:
        d[ip] += [[0, it]]
    it+= 1
print(d)