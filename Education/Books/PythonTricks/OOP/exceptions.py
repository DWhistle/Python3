class MyException(ValueError):
	pass

def validate(s):
	if (s is not str):
		raise MyException
#try-except
try:
	validate(23)
except MyException as ex:
	print(ex)