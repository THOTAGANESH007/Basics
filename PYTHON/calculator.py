import math

# check the type of input
def check_type(value):
    if not type(value) is int:
        raise ValueError("Only integers are allowed!!!")
    else:
        return value
    
# base calss to perform the calculation
def perform_calculation(take_input,first_number,second_number):
    match take_input:
        case 0:
            return "Ok, Bye! Thank you for using our calculator"
        case 1:
            return f"sum of {first_number} and {second_number} is: {first_number + second_number}"
        case 2:
            return f"difference of {first_number} and {second_number} is: {first_number - second_number}"
        case 3:
            return f"product of {first_number} and {second_number} is: {first_number * second_number}"
        case 4:
            return f"division of {first_number} and {second_number} is: {first_number / second_number}"
        case 5:
            return f"{first_number}raised to the power{second_number}results: {first_number ** second_number}"
        case 6:
            return f"square roots of {first_number} and {second_number} are: {math.sqrt(first_number)}, {math.sqrt(second_number)}"
        case _:
            return "Please Enter a valid number"

# runner function
try:
    first_number = int(input("Enter first number:"))
    check_type(first_number)
    second_number = int(input("Enter second number:"))
    check_type(second_number)
    while True:
        take_input = int(input("\n 1-> Addition\n 2-> Subtraction\n 3-> Multiplication\n 4-> Division\n 5-> Power\n 6-> Square Root\n 0-> EXIT\n Enter a number to perform the operation:"))
        if(take_input==4 and second_number==0):
            print("please enter a valid second number\ndivision with zero is not possible")
            break
        print(f"\nOutput:{perform_calculation(take_input,first_number,second_number)}")
        if take_input == 0:
            break
except ValueError as e:
    print(f"Exception: {e}")
    
    

