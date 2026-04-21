```
class LRUCache:
    class Node: 
        def __init__(self, key, value): 
            self.key = key
            self.value = value 
            self.prev = None 
            self.next = None

    def __init__(self, capacity: int):
        self.capacity = capacity 
        self.key_dict = {}
        self.head = self.Node(-1, -1)
        self.tail = self.Node(-1, -1)
        self.head.next = self.tail 
        self.tail.prev = self.head 

    def remove_node(self, node): 
        node.prev.next = node.next 
        node.next.prev = node.prev 
    
    def add_node(self, node): 
        node.prev = self.head 
        node.next = self.head.next 
        self.head.next.prev = node 
        self.head.next = node

    def get(self, key: int) -> int:
        if key not in self.key_dict: 
            return -1 

        # updates it as the most recently used element
        curr_node = self.key_dict[key]
        self.remove_node(curr_node)
        self.add_node(curr_node)
        return curr_node.value
        

    def put(self, key: int, value: int) -> None:
        if key in self.key_dict: 
            curr_node = self.key_dict[key]
            curr_node.value = value 
            self.get(key)
            return 
        
        if len(self.key_dict) == self.capacity: 
            lruElement = self.tail.prev
            self.remove_node(lruElement)
            del self.key_dict[lruElement.key]
        
        new_node = self.Node(key, value)
        self.add_node(new_node)
        self.key_dict[key] = new_node
        


# Your LRUCache object will be instantiated and called as such:
# obj = LRUCache(capacity)
# param_1 = obj.get(key)
# obj.put(key,value)
```