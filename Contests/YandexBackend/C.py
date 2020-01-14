n = int(input())


ak = []
av = []
bk = []
bv = []
c = []

for i in range(n):
    elem = input().split()
    ak.append(elem[0])
    av.append(elem[1])

m = int(input())

for i in range(m):
    elem = input().split()
    bk.append(elem[0])
    bv.append(elem[1])

joinType = input()

for key in range(n):
    if ak[key] in bk:
        c.append([ak[key], av[key], bv[key]])
    if bk[key] in ak:
        c.append([bk[key], bv[key], av[key]])
if joinType == 'LEFT' or joinType == 'FULL':
    for key in range(n):
        if ak[key] not in bk:
            c.append([ak[key], av[key], 'NULL'])
if joinType == 'RIGHT' or joinType == 'FULL':
   for key in range(m):
        if bk[key] not in ak:        
            c.append([bk[key], 'NULL', av[key]])

print (len(c))
for key, value, value2 in c:
    print(key, value, value2)

