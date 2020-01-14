length = int(input())
int1 = []
int2 = []
it = 0
while it < length:
    i1, i2 = input().split(" ")
    int1 += [int(i1[0])]
    int2 += [int(i2[0])]
    it += 1

min_int = 1 
max_int = 1 
time = int1[0] 
i = 1 
j = 0 
while (i < length and j < length): 
    if int1[i] <= int2[j]: 
        min_int = min_int + 1 
        if min_int > max_int: 
            max_int = min_int 
            time = int1[i]; 
        i = i + 1    
    else: 
        int_int = min_int - 1 
        j = j + 1

print(max_int)
      