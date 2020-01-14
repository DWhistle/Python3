cast = ["1", "2", "3", "4"]
#print(cast[1])
#print(len(cast))
cast.append(["123", 323232])
#print(cast[4])
cast.pop()
#print(len(cast))
cast.extend(["abc, asb"])
#print(cast[4])
cast.remove("1")
cast.insert(0, 121312321)
#print(cast[0])



numbers = ["\"1\"", "2", "3", "4"]
it = 0
for i in range(len(numbers)):
    numbers.insert(it + 1, i + 22)
    it+=2
numbers.append([123, "323232"])
#for i in numbers:
  #  print(i)






