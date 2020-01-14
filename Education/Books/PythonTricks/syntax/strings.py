#printf-styled
errno = 5343422
name = 'Bob'
print("Hey, %s, the mistake is %x" % (name, errno))


#mapping
print("Hey, %(name)s, the mistake is %(errno)x" % {'name' : name, 'errno' : errno})


#format
print('Hey, {}'.format(name))


#format + mapping
print('Hey, {name}! The error is {errno:x}'.format(name=name, errno=errno))


#interpolation
print(f'Hey, {name}, the error is {errno:#x}')


#template strings
from string import Template
t = Template("Hey, $name")
print(t.substitute(name = name))