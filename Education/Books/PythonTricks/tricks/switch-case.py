def my(a,b):
	return a + b
def my2(a,b):
	return a - b
def default(a,b):
	return a * b
funcs = [my]
print(funcs[0](1,2))
func_dict = {
	'a' : my,
	'b' : my2,
}
cond = 'b'
print(func_dict.get(cond, default)(1,2))
print(func_dict.get('c', default)(5,2))

#switch-case
def dispatch_if(operator, x, y):
	if operator == 'add':
		return x + y
	elif operator == 'sub':
		return x - y
	elif operator == 'mul':
		return x * y
	elif operator == 'div':
		return x / y

def dispatch_dict(operator, x, y):
	return {
	'add': lambda: x + y,
    'sub': lambda: x - y,
    'mul': lambda: x * y,
    'div': lambda: x / y,
	}.get(operator, lambda:None)()

print(dispatch_dict('mul', 1, 2), dispatch_if('mul', 1, 2))