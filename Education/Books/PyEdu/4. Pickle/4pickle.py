import pickle

man = ["sdsdsds", "sdsadae2e", "12413423423"]
other = [1,2,3,4,5]
try:
    with open('input.txt', 'rb') as man_file, open('other.txt', 'rb') as other_file:
       other =  pickle.load(man_file)
       man =  pickle.load(other_file)
except IOError as e1:
    print('File error: ' + str(e1))
except pickle.PickleError as e2:
    print('Picking error: ' + str(e2))

print(man)
print(other)