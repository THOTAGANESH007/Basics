my_dict = {"apple": 1, "banana": 2, "cherry": 3}

# Try to get the value for 'banana'. It will return 2.
value1 = my_dict.get("banana")
print(f"Value for banana is: {value1}")

# Try to get the value for 'orange'. Key not found, so it returns the default value (None).
value2 = my_dict.get("orange")
print(f"Value for orange is: {value2}")

# You can specify a custom default value instead of None
value3 = my_dict.get("mango", "Key Not Found")
print(f"Value for mango is: {value3}")

"""
def search_student():
    roll_number = int(input("Enter Roll Number of the student: "))
    student_name = input("Enter Name of the student: ")
    return (roll_number, student_name)

print(search_student())

"""

# print(dict(zip(["Hello","jkfd","jfh"],["World","fdh"])))
# print(dict("Hello","World"))

l=[1,1,1,1,1,1,1,2,3,4,4,2,2,7,8,6,5]
print(set(l))