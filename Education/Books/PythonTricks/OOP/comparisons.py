"""
==  - equal contents
is - equal reference objects
"""
arr = [1,2,3]
arrcpy = list(arr)
arrobjcpy = arr
print (arr == arrcpy, arr == arrobjcpy)
print (arr is arrcpy, arr is arrobjcpy)

