'''
lambdas - 1 expression, no annotations or return keyword
'''
add = lambda x, y: x + y
print(add(5, 6))

#one-liner
print((lambda x, y: x + y)(5, 6))

#lambda usage
tuples = [(1, 'd'), (2, 'a'), (3, 'c')]
print(sorted(tuples, key = lambda x: x[1]))

#lambda closures
def make_adder(n):
	return lambda x: x + n

plus_3 = make_adder(3)
print(plus_3(5))