# struct .Struct - serialized C-type structs for storing values

from struct import Struct

my = Struct('i?f')
data = my.pack(23, False, 42.1)
print(data)
print(my.unpack(data))