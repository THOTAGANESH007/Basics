import logging
# Exception class
class AgeError(Exception):
    def __init__(self, age):
        self.age = age
        if age < 0:
            super().__init__(f"Invalid age: {age}")
        elif age < 18:
            super().__init__(f"Bhaai you are not eligible to vote @{age}")
        else:
            super().__init__(f"Go and utilize your vote @{age}")

a1 = AgeError(77)
print(a1)

logging.basicConfig(level=logging.INFO)

def weight(weight):
    if not isinstance(weight, int):
        raise ValueError("The weight should be an integer")
    elif weight < 0:
        raise Exception("The weight should not be negative")
    else:
        return f"Your weight is {weight}"
    
try:
    w = weight("jkfh")
    # w = weight(786)
    
except ValueError as e:
    # print(e)
    logging.warning(f"Dekhlo...{e}")
except Exception as e:
    # print(e)
    logging.error("Dekh kar type")
else:
    # print(w)
    logging.info(w)