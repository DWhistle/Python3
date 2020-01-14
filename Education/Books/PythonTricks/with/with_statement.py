class ManagedFile:
    def __init__(self, name):
    	self.name = name
    def __enter__(self):
    	self.file = open(self.name, 'r')
    	return self.file
    def __exit__(self, exc_type, exc_val, exc_tb):
    	if self.file:
    		self.file.close()

with ManagedFile('with_statement.py') as f:
	print(f.readline(), end='')

