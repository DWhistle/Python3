from typing import NamedTuple
from math import log2
from math import ceil

class Node(NamedTuple):
    left: object
    right: object
    value: object
    key: int


class Heap:

    def __init__(self):
        self._tree = None
        self._elems_num = 12

    def insert(self, nodes):
        pass

    def __restore_heap(self):
        pass

    def find_last(self):
        level  = 2 ** ceil(log2(self._elems_num))
        self.find_last_element(self._elems_num, level)

    def find_last_element(self, prev, level):
        if prev == 1 or prev == 0:
            return prev

        print(prev, level)
        print('left' if level - prev > prev / 2 else 'right')
        prev = prev // 2
        self.find_last_element(prev, level // 2)
        # from_prev = self._elems_num - 2 ** level
        # from_next = 2 ** (level + 1) - 1 - self._elems_num 
        # print((2 ** (level + 1)) // 4)
        # print(2 ** (level + 1) - self._elems_num)
        # print('right' if 2 ** (level + 1) - self._elems_num > (2 ** (level + 1)) // 4 else 'left')
        #print(level, self._elems_num - 2 ** (level + 1) )

Heap().find_last()