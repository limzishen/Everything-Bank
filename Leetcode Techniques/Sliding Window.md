Problems Related to review again: 3578 (fucking cancer problem)

# 239. Sliding Window Maximum
![[Pasted image 20251207184027.png]]
```
from collections import deque
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        # have a queue 
        # iterate through each element 
        # go to front of the queue if its the max 

        q = deque()
        n = len(nums)
        res = []
        for i in range(k): 
            curr = nums[i]
            while q and curr > q[-1]: 
                q.pop()
            q.append(curr)
        res.append(q[0])
        
        for i in range(1, n - k + 1): 
            curr = nums[i + k - 1] 
            if nums[i - 1] == q[0]: 
                q.popleft()
            while q and curr > q[-1]: 
                q.pop()
            q.append(curr)
            res.append(q[0])
        
        return res
```

# 3578 
## DP way to do it 
Will tle with standard dp 
```
class Solution:
    def countPartitions(self, nums: List[int], k: int) -> int:
        # dp + prefix sum + sliding window 
        n = len(nums)
        dp = [0] * (n + 1)
        dp[0] = 1
        o = 10 ** 9 + 7 
        
        # dp[idx] = number of partition from 0 to idx 
        for i in range(1, n + 1): 
            max_e = nums[i - 1]
            min_e = nums[i - 1]
            for l in range(i, 0, -1): 
                max_e = max(max_e, nums[l - 1])
                min_e = min(min_e, nums[l - 1])
                if max_e - min_e <= k: 
                    dp[i] += dp[l - 1]
                    dp[i] %= o
        return dp[n]

```

## DP + Sliding window + prefix sum 
```
class Solution:
    def countPartitions(self, nums: List[int], k: int) -> int:
        # dp + prefix sum + sliding window 
        n = len(nums)
        MOD = 10 ** 9 + 7

        dp = [0] * (n + 1)
        dp[0] = 1

        max_q = deque()
        min_q = deque()

        l = 0 
        pre = [0] * (n + 2)
        pre[1] = 1
        # dp[idx] = number of partition from 0 to idx 
        for i in range(n): 
            while max_q and nums[max_q[-1]] <= nums[i]:
                max_q.pop()

            while min_q and nums[min_q[-1]] >= nums[i]: 
                min_q.pop()

            max_q.append(i)
            min_q.append(i)

            while (nums[max_q[0]] - nums[min_q[0]]) > k: 
                # move the left pointer to a point where the max and min is within k
                if max_q[0] == l: 
                    max_q.popleft()
                
                if min_q[0] == l: 
                    min_q.popleft()
                l += 1 
            dp[i + 1] = (pre[i + 1] - pre[l] + MOD) % MOD 
            pre[i + 2] = (pre[i + 1] + dp[i + 1]) % MOD 
        return dp[n]
```