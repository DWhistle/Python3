from contextlib import contextmanager
import time

@contextmanager
def measure_performance(method):
	starting_time = time.time()
	try:
		yield method
	finally:
		print()
		print("Execution time = ", time.time() - starting_time)

def test():
	for i in range(900000000):
		pass
with measure_performance(test) as m:
	m()