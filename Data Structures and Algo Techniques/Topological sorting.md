# Kahn algorithm 
Logic is similar to bfs

```
class Solution:
    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        # build a graph 
        # find the topological ordering (kahn/DFS)

        # build a adjacency list
        graph = {}
        for i in range(numCourses): 
            graph[i] = []

        in_degree = [0] * numCourses
        for a, b in prerequisites: 
            graph[b].append(a)
            in_degree[a] += 1 
        
        print(graph)
        print(in_degree)

        queue = deque()
        for i in range(numCourses): 
            if in_degree[i] == 0: 
                queue.append(i)

        ans = []
        while queue: 
            index = queue.popleft()
            ans.append(index)
            for child in graph[index]: 
                in_degree[child] -= 1
                if in_degree[child] == 0: 
                    queue.append(child)
            graph[index] = []   
        

        # this if statement is needed because the there might by cyclical argument
        return ans if len(ans) == numCourses else []
```