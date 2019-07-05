
s = input()
length = 0
it = 0
while it < len(s):
    if s[it].isdigit():
        temp = ""
        while it < len(s) and s[it].isdigit():
            temp += s[it]
            it += 1
        length += int(temp)
        it += 1
    else:
        length += 1
        it += 1
if s[it - 2].isdigit():
    length -= 1
    
print(length)