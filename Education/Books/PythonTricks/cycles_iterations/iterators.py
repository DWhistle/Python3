

class Repeater:
	def __init__(self, value):
	 self.value = value
	def __iter__(self):
		return Iterator(self)

class Iterator:
	def __init__(self, source):
		self.source = source
	def __next__(self):
		return self.source.value

repeater = Repeater('hi')
it = iter(repeater)
print(next(it), next(it))
#for item in repeater:   ## infinite iterations
#	print(item)

# same as 2 previous
class Repeater:
	def __init__(self, value):
	 self.value = value
	def __iter__(self):
		return self
	def __next__(self):
		return self.value



repeater = Repeater('hi')

list_iter = [1,2,3].__iter__()
print(next(list_iter),next(list_iter),next(list_iter))

#iterating with bounds
class BoundedIterator:
	count = 0
	def __init__(self, value):
	 self.value = value
	def __iter__(self):
		self.__class__.count = 0
		return self
	def __next__(self):
		self.__class__.count +=1 
		if (self.__class__.count > 5):
			raise StopIteration
		return self.value + str(self.__class__.count)

repeater = BoundedIterator('hello')
for i in repeater:
	print(i)
print()
for i in repeater:
	print(i)