d = {True: 'да', 1: 'нет', 1.0: 'возможно'}

print(d[True])

#booleans are subclasses of int
print(['no', 'yes'][True])

#happens because of equal hashes
print(hash(1), hash(True), hash(1.0))

#dict keys are equal, if hashes are equal and __eq__ gives True