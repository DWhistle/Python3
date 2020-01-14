from contextlib import contextmanager
class Indenter():
	def __init__(self):
		self.level = 0

	def __enter__(self):
		self.level += 1
		return self
	def __exit__(self, exc_type, exc_val, exc_tb):
		self.level -= 1
	def print(self, text):
		print(' ' * self.level + str(text))


with Indenter() as ind:
	ind.print(1)
	with ind:
		ind.print(2)
		with(ind):
			ind.print(3)
		ind.print(4)
	ind.print(5)