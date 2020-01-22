tup = ('hey', 2, object())
"""
tuple - only by index reading
namedtuple - reading by identifier
both are immutable
"""
from collections import namedtuple
#could create class-like objects with namedtuple
Car = namedtuple('Car', 'color engine')
car = Car('red', '200hp')
print(car, car.color, car.engine)

#could be used as usual tuples
print(car[0], car[1])
color, power = car
print(color, power)

"""
namedtuple is created with class creation principle and more memory-effective
"""
#inheritance from namedtuple
class CarWithMethods(Car):
	def hexcolor(self):
		print(f'{self.color:x}')
carm = CarWithMethods(20323, '100hp')
carm.hexcolor()
#new namedtuple from old one
ElectricCar = namedtuple('ElectricCar', Car._fields + ('charge',))
#utilities
print('charge' in ElectricCar._fields)
print(dict(carm._asdict()))
print(carm._replace(engine = 100))
print(ElectricCar._make([222, 222, 232]))



#NamedTuple (better namedtuple)
from typing import NamedTuple
class Car(NamedTuple):
	color: str
	hp: int
	wd4: bool
c = Car('red', 23, True)
print(c)
print(c.color)
c.driver = 'Ivan'