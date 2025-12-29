import math
n = int(input("Enter number of elements in the list:"))
# nums=[None]*n
nums =[int(input("Enter: ")) for _ in range(n)]
    
largest = -math.inf
for num in nums:
    if num > largest:
        largest = num
        
print("The Largest Number in the list:", largest)

second_largest = -math.inf

for num in nums:
    if num > largest:
        largest = num
        second_largest = largest
    elif num > second_largest and num != largest: #removes duplicates
        second_largest = num
        
print("Second largest element of the list is:",second_largest)