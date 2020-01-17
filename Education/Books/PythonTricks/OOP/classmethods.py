class MyClass:
	def m1(self):
		return str(self)
	@classmethod
	def m2(cls):
		return (str(cls))
	@staticmethod
	def m3():
		return 'static'