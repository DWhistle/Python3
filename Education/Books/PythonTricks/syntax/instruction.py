'''
_var - 'private' variable or method (!!!wildcard import for methods!!!)

'''

class Test1:
	def __init__(self):
	 self.foo = 23
	 self._bar = 22 

print(Test1().foo, Test1()._bar)


'''
class_ - naming conflicts
'''


'''
__bar - sets class prefix to avoid overriding (_Test2__bar)
'''
class Test2:
	def __init__(self):
	 self.foo = 23
	 self.__bar = 22 

print(', '.join(Test2().__dir__()))
class T2Ext(Test2):
	def __init__(self):
	 super().__init__()
	 self.foo = 666
	 self.__bar = 666
print(T2Ext()._Test2__bar, T2Ext()._T2Ext__bar)


'''
__init__ - system reserved words (dunder methods)
'''


'''
_ - unnessessary variables
'''

for _ in range(3):
	print('Hello', end=' ')
car = ('red', '4wd')
_, drive = car
