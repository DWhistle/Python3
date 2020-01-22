#list ...

#tuple (immutable)
tup = '1', '2', '3'
print(tup)

#arrays
from array import array

arr = array('f', (1.0, 1.5))
print(arr[1])
arr[0] = 2.1
del arr[1]
# arr[0] = 'hello' error

#strings

arr = 'abcd'
# arr[1] = 'e' error
print(list(arr))
print(type(arr), type(arr[0])) # 1 symbol is type str

#bytes(integers >= 0 && <= 255)
arr = bytes((0, 1, 2, 3))
print(arr[0])
print(arr)
#arr[1] = 23 error

#bytearray(mutable bytes)
arr = bytearray((1,2,3,4))
arr[1] = 23
print(arr)
print(bytes(arr))