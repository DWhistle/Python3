#queue != list
from collections import deque #O(1) queue
deq = deque([1,2,3])
deq.popleft()
deq.popleft()

#deque.LifoQueue - blocking queue(parallel computing)
from queue import LifoQueue
s = LifoQueue()
s.put('1')
#print(s.get_nowait()) - blocks
print(s.get())

#PriorityQueue
from queue import PriorityQueue
q = PriorityQueue()
q.put((2, 'sleep'))
q.put((1, 'eat'))
q.put((3, 'code'))
while not q.empty():
     next_item = q.get()
     print(next_item)