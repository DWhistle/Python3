import collections
d = collections.OrderedDict(one=1, two=2, three=4)
print(d['three'])
d.update({'1' : 12})
print(d.keys())

# sets default value if it's absent
from collections import defaultdict

dd = defaultdict(list)

dd['1'].append(1)
dd['1'].append(11)
print(dd)

#searches multiple tables for matches left to right
from collections import ChainMap

cm = ChainMap(dd, d)
print(cm)
print(cm['1'])
print(cm['23'])

#immutable dict
from types import MappingProxyType
mp = MappingProxyType(cm)
mp['1'] = 2
