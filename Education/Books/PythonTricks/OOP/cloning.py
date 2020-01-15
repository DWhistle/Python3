"""
assignments don't create copies, only chain names to objects
"""

#fabric methods cloning (shallow copy)
list1 = [1,2,3]
list1cpy = list(list1)

"""
shallow copy constructs new object, filled with links to child objects(dependent cloning)
deep copy is made recursively(independent cloning)
"""


#shallow copy

shallowlist = [['a', 'b'],[121,2323123,1],[123,232],]
shallowcpy = list(shallowlist)
shallowcpy[0][1] = 12
print (shallowlist)

#deep copying
import copy
xs = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
ys = copy.deepcopy(xs)
ms = copy.copy(xs) #shallow
ys[0][1] = 12
print(ys == xs)