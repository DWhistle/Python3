#!/usr/bin/env python
# coding: utf-8

# ### Naive Array-Heap implementation for the Course problem solving

# In[31]:


from typing import NamedTuple
from math import floor, ceil
from enum import Enum

class HeapType(Enum):
    MAX = lambda x: -x
    MIN = lambda x: x
        
class ArrayHeap:
    @staticmethod
    def __previous_elem(index):
        if index == 0:
            return index
        return int(index / 2 - 1 if index % 2 == 0 else floor(index / 2))

    @staticmethod
    def __next_elems(index):
        return index * 2 + 1, index * 2 + 2
    
    def __is_heap_property(self, root, leaf):
        return self.comp(self.data[root]) <= self.comp(self.data[leaf])
        
    def __swap(self, ind1, ind2):
        data = self.data
        data[ind1], data[ind2] = data[ind2], data[ind1]

        
    def __init__(self, values = [], comparator = HeapType.MIN):
        self.comp = comparator
        self.data = sorted(values, key = comparator) if len(values) else []
        
    
    def __repr__(self):
        return repr(self.data)
    
    def __restore_heap(self):
        current_index = len(self.data) - 1
        preceding_index = ArrayHeap.__previous_elem(current_index)
        while True:
            if not self.__is_heap_property(preceding_index, current_index):
                self.__swap(preceding_index, current_index)
            else:
                break
            current_index, preceding_index = preceding_index, ArrayHeap.__previous_elem(preceding_index)
        
    def __find_smallest_descendant(self, root, left, right):
        data = self.data
        is_left = len(data) > left
        is_right = len(data) > right
        if is_left:
            if not is_right:
                return left
            return left if self.comp(data[left]) < self.comp(data[right]) else right
        return -1
        
    def extract_top(self):
        data = self.data
        if len(data) == 1:
            return data.pop(0)
        elif len(data) == 0:
            return None
        top = self.data[0]
        data[0] = data.pop()
        left, right = ArrayHeap.__next_elems(0)
        root = self.__find_smallest_descendant(0, left, right)
        if root < 0:
            return top
        self.__swap(root, 0)
        while True:
            left, right = ArrayHeap.__next_elems(root)
            smallest = self.__find_smallest_descendant(root, left, right)
            if smallest < 0:
                return top
            
            if not self.__is_heap_property(root, smallest):
                self.__swap(root, smallest)
                root = smallest
            else:
                break
        return top
    
    def lookup_top(self):
        if len(self.data):
            return self.data[0]
        
    def __len__(self):
        return len(self.data)
    
    def insert(self, values):
        if type(values) is not list:
            values = [values]
        for v in values:
            if type(v) is not int:
                raise TypeError("Integers are allowed only")
            self.data.append(v)
            self.__restore_heap()


# In[32]:


def test_heap():
    heap = ArrayHeap([1,2,3,4,5,6,7,8], HeapType.MIN)
    heap2 = ArrayHeap([1,2,3,4,5,6,7,8], HeapType.MAX)
    heap.insert([0, 13, 2])
    heap2.insert([0, 13, 2])
    print(heap)
    print(heap2)
    while True:
        e = heap2.extract_top()
        print(e)
        if e is None:
            break

        print('======================')

