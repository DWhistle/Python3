class Solution:
    def climbStairs(self, n: int) -> int:
        
        cache = {}

        def stairs(n: int) -> int:
            if n in cache:
                return cache[n]
            varis = 0
            if n > 1:
                varis +=1
                varis += stairs(n - 1)
                varis += stairs(n - 2)
                cache[n] = varis
            return varis
        
        return stairs(n) + 1