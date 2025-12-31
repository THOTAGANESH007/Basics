def decorator(func):
    def wrapper():
        print("Before calling the function.")
        func()
        print("After calling the function.")
    return wrapper

# @decorator syntax is a shorthand for greet = decorator(greet).

@decorator # Applying the decorator to a function
def greet():
    print("Hello, World!")
greet()



def decorator_name(func):
    def wrapper(*args, **kwargs):
        print("Before execution")
        result = func(*args, **kwargs)
        # print(result)
        print("After execution")
        return result
    return wrapper

@decorator_name
def add(a, b):
    return a + b

print(add(5, 3))