#functions returned from functions
def speak_func(volume):
	def yell(text):
		return text.upper() + '!'
	def whisper(text):
		return text.lower()
	if volume > 1:
		return yell
	else:
		return whisper
print(speak_func(1)('hey'))
print(speak_func(2)('heeeeey'))

#closures
def speak_func_closure(volume, text):
	def yell():
		return text.upper() + '!'
	def whisper():
		return text.lower()
	if volume > 1:
		return yell
	else:
		return whisper
print("\n###CLOSURES###")
print(speak_func_closure(1, 'hey')())
print(speak_func_closure(2, 'heeeeey')())


#factory of methods
def make_adder(n):
	def add(x):
		return x + n
	return add
plus_3 = make_adder(3)
print(plus_3(plus_3(4)))

#callable objects
class Adder:
	def __init__(self, quant):
		self.q = quant
	def __call__(self, x):
		return x + self.q

plus_5 = Adder(5)
print(plus_5(4))

#check if callable
print(callable(plus_3))
print(callable('s'))