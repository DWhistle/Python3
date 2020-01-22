class MyClass:
	def m1(self):
		return 'obj', self
	@classmethod
	def m2(cls):
		return 'class', cls
	@staticmethod
	def m3():
		return 'static'

my = MyClass()
print(my.m1()) ; print (MyClass.m1(my)) # ==
print(my.m2())
print(my.m3())
print(my.__class__.m2())