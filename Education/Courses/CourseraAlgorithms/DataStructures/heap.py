from typing import NamedTuple
from math import log2
from math import ceil, floor

class Node:
    def __init__(self, key, left = None, right = None, value = None):
        self.left = left 
        self.right = right
        self.value = value
        self.key = key



class Heap:

    def __init__(self):
        self._tree = None
        self._elems_num = 0

    def insert(self, nodes):
        path = self.find_last().reverse()
        node: Node = self._tree
        for i in range(1, len(path)):
            if path[i] % 2 == 0:
                node = node.left
            else:
                node = node.right
        print(node)
        

    def __restore_heap(self):
        pass

    def find_last(self):
        return self.find_last_element(self._elems_num)

    def find_last_element(self, prev):
        if (prev <= 1):
            return []
        p = prev // 2 if prev % 2 == 0 else floor(prev / 2)
        return [p] + self.find_last_element(p) 
h = Heap()
n = Node(1)
n.left = Node(2)


print(Heap().find_last())