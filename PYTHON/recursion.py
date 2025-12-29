def fibonacci(n):
    if n<=1:
        return n
    return fibonacci(n-1)+fibonacci(n-2)

def factorial(n):
    if n<0:
        return "Invalid Input!!!"
    if n<=1:
        return 1
    return n*factorial(n-1)

def linear_search(l,key):
    i=0
    for ele in l:
        if ele == key:
            return f"Key Found!!! at index {i}"
        i += 1
    else:
        return "Key Not Found!!!"
    
def binary_search(l,key):
    start = 0
    end = len(l)-1
    while start <= end:
        mid = (start+end) // 2
        if l[mid] == key:
            return f"Key Found!!! at index {mid}"
        elif l[mid] < key:
            start = mid+1
        else:
            end = mid-1
    else:
        return "Key Not Found!!!"
 
print(fibonacci(7))

print(factorial(7))

print(linear_search([7,1,2,3,4,8,7],7))

print(binary_search([1,2,3,4,5,6,7,8,9],7))