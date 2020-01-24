
#equal to infinite iterator
def repeater(value):
	while True:
		yield value #returns control to the caller(saves local state)

# for i in repeater("hello"):
# 	print(i)
r = repeater('hi')
print(next(r))
print(r)

#repeator from generator
def repeat_three_times(value):
	yield value
	yield value
	yield value
for x in repeat_three_times('hi'):
	print(x)
g = repeat_three_times("hello")
next(g); next(g), next(g)
#next(g) StopIteration

def bounded_repeator(value, max_rep):
	for x in range(max_rep):
		yield value

for h in bounded_repeator('123', 3):
	print(h)

#generator expression
iterator = ('hey' for i in range(3))
lst = ['hey' for i in range(3)]
print(iterator)
print(lst) #list is fully generated

#inlining
for x in ('bue' for i in range(3)):
	print(x)

#generators use RAM effectively
sum((x * 2 for x in range(3)))
sum(x * 2 for x in range(3))

blue = ['blue' for x in range(3)]
red = ['red' for x in range(3)]
green = ['green' for x in range(3)]

#multiple conditions cycle
# for x in xs:
#      if cond1:
#          for y in ys:
#              if cond2:
#                  ...
#                      for z in zs:
#                          if condN:
#                              yield expr
#====================
# (expr for x in xs if cond1
#        for y in ys if cond2
# 	          for z in zs if condN)
gen = (m for b in blue if len(b) > 0 for g in green if len(g) > 0  for m in red if len(m) > 0)
print(next(gen))


#chains of generators
def integers():
	for i in range(1,9):
		yield i
def squared(seq):
	for i in seq:
		yield i * i
def neg(seq):
	for i in seq:
		yield -i
seq = neg(squared(integers()))
print(seq, next(seq), next(seq))
print(list(neg(squared(integers()))))

#shortened
integers = range(8)
squared = (i * i for i in integers)
negated = (-i for i in squared)
print(list(negated))