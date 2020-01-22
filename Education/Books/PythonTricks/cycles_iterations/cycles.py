#indexed cycles
for i, item in enumerate([1,2,3]):
	print(f'{i}: {item}')

print("#map iteration")
emails = {
    'Bob': 'bob@example.com',
     'Alice': 'alice@example.com',
}
for name, email in emails.items():
    print(f'{name} -> {email}')


#inclusions
squares = [x * x for x in range(10) if x * x % 3 == 0]
mapinc = {x: x * x for x in range(5) }
print(squares)
print(mapinc)


#slicing
print(squares[3:5:2]) #first:last:step
del squares[:]
print(squares)