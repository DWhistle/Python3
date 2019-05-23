class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        if head and head.next:
            temp = self.reverseList(head.next)
        else:
            return head
        head.next.next = head
        head.next = None
        return temp