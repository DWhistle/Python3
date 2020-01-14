def yell(text):
	return text.upper() + '!'

#functions = objects
bark = yell
print(bark('wooo'))
#we only delete reference, not function
del yell
try:
	yell('aha')
except Exception:
	print(bark('alive'))
	pass
#functions have name attribute
print(bark.__name__)
#could be stored
funcs = [bark, str.capitalize, str.upper]
print(funcs)
#iterated
for f in funcs:
	print(f('string'), end=', ')
#called by index
print(funcs[0]('magic'))
#passed to funcs
def greet(func):
	print(func('hi'))

##high-order functions
print(list(map(bark, ['hey', 'hello'])))

