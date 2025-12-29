def convert_age(convert_to,weight):
    match convert_to.lower(): #str.casefold()
        case 'l':
            return f"You are {(weight*0.45):.2f} kilos"
        case 'k':
            return f"You are {(weight/0.45):.2f} pounds"
        case _:
            return "incorrect input"


while True:
    weight = int(input("Enter your weight:"))
    convert_to = input("Convert to K(g) or L(bs):")

    result = convert_age(convert_to,weight)
    print(result)
    to_terminate=input("Enter any key to continue or type 'exit' to terminate:")
    if to_terminate=='exit':
        break
