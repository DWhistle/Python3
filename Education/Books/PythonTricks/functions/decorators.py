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

#multiple decorators
def strong(func):
	def wrapper():
		return '<strong>' + func() + '</strong>'
	return wrapper

def emphasis(func):
	def wrapper():
		return '<em>' + func() + '</em>'
	return wrapper

@strong # - 2nd call
@emphasis # - 1st call
def greet():
	return 'Hello'
print(greet())

#method tracing with decorators
def tracing(func):
	def wrapper(*args, **kwagrs):
		print(f'called {func.__name__} with {args}, {kwagrs}')
		result = func(*args, **kwagrs)
		print(f'returned {result}')
		return result
	return wrapper

@tracing
def test(k, v, n):
	return k + v + n
print(
'''
standart decorator erases metadata, should use @functools.wraps(funcs)
''', end='')
from functools import wraps
def tracing(func):
	@wraps(func)
	def wrapper(*args, **kwagrs):
		print(f'called {func.__name__} with {args}, {kwagrs}')
		result = func(*args, **kwagrs)
		print(f'returned {result}')
		return result
	return wrapper

@tracing
def test(k, v, n):
	"""returns sum"""
	return k + v + n
print(test.__name__)
print(test.__doc__)

##93