def foo(required, *args, **kwargs):
    print(required)
    if args:
    	print(args)
    if kwargs:
    	print(kwargs)


foo('req', 1,2,3,4,5, k=42)

#args modifying
def bar(required, *args, **kwagrs):
	kwagrs['name'] = 'Bob'
	new_args = args + ('11',)
	foo(required, new_args, kwagrs)
bar('req', 1,2,3,4,5, k=42)


#envelope functions and constructors
class Car:
	def __init__(self, color, mileage):
		self.color = color
		self.mileage = mileage
class AlwaysBlueCar(Car):
	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		self.color = 'blue'
print(AlwaysBlueCar('green', 232).color)


#multipurpose decorators
import functools
def trace(f):
	@functools.wraps(f)
	def decorated_function(*args, **kwargs):
		print(f, args, kwargs)
		result = f(*args, **kwargs)
		print(result)
	return decorated_function
@trace
def greet(greeting, name):
	return '{}, {}!'.format(greeting, name)

greet('hey', 'me')


#args dispatch
def print_vector(x, y, z):
	print('<%s, %s, %s>' % (x, y, z))

vec1 = [1,2,3]
vec2 = (1,2,3)
print_vector(*vec1) #same as print_vector(vec1[0], vec1[1], vec1[2]):
print_vector(*vec2)

genexp = (x * x for x in range(3))
print_vector(*genexp)

#kwargs dispatch
d_vec = {'x' : 1, 'y': 2, 'z': 3}
print_vector(**d_vec)


#return values
def foo():
	pass
def bar():
	pass
	return None
#foo == bar
