def greet(name):
	return f'Hey, {name}'

print (greet.__code__.co_code)
print (greet.__code__.co_consts)
print (greet.__code__.co_varnames)

#disassembling
import dis
print(dis.dis(greet))