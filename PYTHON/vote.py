age = int(input("Enter your age:"))
if age > 18:
    print("You are eligible to vote")
elif age == 18:
    print("Please apply for the voter card")
else:
    print("You are not eligible to vote")