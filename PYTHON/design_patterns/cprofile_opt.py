import cProfile

def for_function():
    total = 0
    for i in range(10_000):
        total += i
    return total

def sum_function():
    return sum(range(10_000))

def main():
    for _ in range(100):
        for_function()
        sum_function()

# cProfile.run("main()")
# python3 -m cProfile myscript.py => For the complete File

# cProfile → “Where is my program slow?”