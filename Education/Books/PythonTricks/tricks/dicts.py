

names = {
	1 : 'Alice',
	2 : 'Bob',
	3 : 'Robert',
}
#straightforward dict search
def greeting(userid):
	return f'Hey, {names[userid]}'

print(greeting(2))

#default parameter
def greeting(userid):
	return f'Hey, {names.get(userid, "everyone")}'

print(greeting(22))


#sorting
print(names) # could be not sorted by default
#sorting by value
sorted(names.items(), key=lambda x : x[1])

import operator
#operators
sorted(names.items(), key=operator.itemgetter(1))

#sorting by abs key in reversed
sorted(names.items(), key=lambda x: abs(x[0]))


#updating dicts
d1 = {'1':'1', '2':2, '3':3}
d2 = {'1':'1', '2':5, '3':3}
d1.update(d2)
#collision resolve by last addition
print(d1)

#more ways
d3 = dict(d1, **d2)
d4 = {**d1, **d2}
print(d3,d4)

#for better printing and serializing
import json

print(json.dumps(d1, indent=4))

#pprint for printing complex objs
import pprint

pprint.pprint({1: 2, 2: (1,2,3), 3: {1,2,3}})