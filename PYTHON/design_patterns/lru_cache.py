from functools import lru_cache

@lru_cache(maxsize=128)
def square(n):
    print("Computing...")
    return n * n

print(square(7))
print(square(70))
print(square(7))
print(square.cache_info()) # CacheInfo(hits=1, misses=2, maxsize=128, currsize=2)
