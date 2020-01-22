vowels = {'a', 'e'}
squares = {x * x for x in range(10)}
#better create with set()
print('a' in vowels)
letters = set('alice')

print(letters.intersection(vowels))
vowels.add('x')

#frozenset - immutable set
fs = frozenset(letters)
# fs.add('2') error

#counting keys
from collections import Counter
inventory = Counter()
l = {'blade': 1, 'arrow' : 2}
inventory.update(l)
print(inventory)
inventory.update(l)
print(inventory)
len(inventory) #unique elems
print(sum(inventory.values())) #all