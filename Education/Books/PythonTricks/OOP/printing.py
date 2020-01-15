"""
__str__ - toString()
__repr__ - interpretator output and containers
!!if __str__ not defined, __repr__ is called!!
"""
class Car:
	def __init__(self, color):
		self.name = 'Car'
		self.color = color
	def __str__(self):
		return f'{self.color} {self.name}'
	def __repr__(self):
		#use repr of color and name
		return f'{self.__class__.__name__}({self.color!r})'

print(Car('green'))
print([Car('red')])


#date str methods
import datetime
today = datetime.date.today()
print("##EXAMPLE##")
print(today)
print(repr(today))