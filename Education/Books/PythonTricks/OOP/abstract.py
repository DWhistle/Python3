#naive abstract classes
class Base:
	def foo(self):
		raise NotImplementedError()
	def bar(self):
		raise NotImplementedError()

class Impl(Base):
	def foo(self):
		print('foo')

Impl().foo()
try:
	Impl().bar()
except NotImplementedError as e:
	print(e)

#abstract classes using abc package
from abc import ABCMeta, abstractmethod

class Base(metaclass=ABCMeta):
	@abstractmethod
	def foo(self):
		pass
	@abstractmethod
	def bar(self):
		pass

class Impl(Base):
	def foo(self):
		pass

# Impl() gives an error