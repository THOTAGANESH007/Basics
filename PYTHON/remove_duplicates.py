n = int(input("Enter number of elements in the list:"))
# nums=[None]*n
dic = {'a':1, True:'fkk', 'g':'g'}

for d in dic:
    print(dic.get(d,"j"))
print(dic.get('y',dic))
nums =[int(input("Enter: ")) for _ in range(n)]

for num in nums:
    if nums.count(num)>1:
        nums.remove(num)

print("List after removing the duplicates:",nums)

# List Methods:
"""list.append(num)
list.clear() # empties the list
list.copy() # copies the original list
list.count(num) # returns the count of the num
list.extend(list) # extends the existing list with the new list
list.sort() # reverse=True -> descending order
list.reverse()
list.index(num) # returns the first occurence value index
list.remove(num) # raises value error if the num is not present
list.insert(index, num)
list.pop() # pops the last value of the list"""