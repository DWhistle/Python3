class Dog:
	num_legs = 4 # class variable

	def __init__(self, name):
		self.name = name #object variable
d = Dog("mike")
print(Dog("Jack").name, Dog("Spike").name)
print(Dog.num_legs, Dog("").num_legs)
d.num_legs = 6
print(Dog.num_legs, d.num_legs, d.__class__.num_legs)

#global objects counter
class CountedObject:
	num_instances = 0
	def __init__(self):
		self.__class__.num_instances += 1
		# self.num_instances += 1 Wrong