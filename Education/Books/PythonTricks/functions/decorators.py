'''
decorator provides additional behavior without changing function
'''

def null_decorator(func):
	return(func)

@null_decorator
def greet():
	print('Hello')

def uppercase(func):
	def upp():
		original = func()
		modified = original.upper()
		return modified
	return upp
@uppercase
def greet():
	return('hi')
print(greet())
