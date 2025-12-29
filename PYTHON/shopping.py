import csv

class shopping:
    #class level variables
    discount_rate = 0.2
    all_instances = []
    def __init__(self, name:str, price:float, quantity:int): #predefined datatypes
        
        #assert statements for checking the validity
        # assert condition, userdefined_error_message
        assert price >= 0, f"price must be greater than zero"
        assert quantity > 0, f"quantity should be atleast one or should not be -ve"
        self.__name = name
        self.price = price
        self.quantity = quantity
        self.all_instances.append(self)
        
    def calculate_total_price(self):
        return self.price * self.quantity
    
    def after_applying_discount(self):
        # only the class level variable is considered no matter the which value we pass
        # return self.price * shopping.discount_rate
        
        # It dynamically accesses the variable either from the class level or from the self
        discount = self.price * self.discount_rate
        return self.price - discount
    
    @property #sets the properties to readonly and restrict the reassigning of attributes
    def name(self):
        return self.__name ## private member (__)
    @name.setter
    def name(self, value): # always accepts the value
        self.__name = value
        
    @classmethod
    def load_data(cls):
        with open ('data.csv','r') as f:
            reader = csv.DictReader(f)
            items = list(reader)
        for item in items:
            print(f"shopping('name = {item.name}', 'price = {item.price}', 'quantity = {item.quantity}')")
            
    @staticmethod
    def is_integer(num_list):
        count = 0
        for num in num_list:
            if isinstance(num, float):
                # count the values with the decimal point 0 (7.0, 10.0, 12.0)
                if num.is_integer():
                    count += 1
            elif isinstance(num, int):
                count += 1
            else:
                pass
        return count
    def __repr__(self):
        return f"shopping('{self.name}', '{self.price}', '{self.quantity}')"
    


class child(shopping):
    def __init__(self, name, price, quantity):
        super().__init__(name, price, quantity)
shopping_instance_1 = shopping("Earphones", 500, 7)
# we can also do like the below

shopping_instance_1.name="Mouse"
# shopping_instance_1.price = 200
# shopping_instance_1.quantity = 3

#calling the method
print(shopping_instance_1.calculate_total_price())
print("Price After Discount:",shopping_instance_1.after_applying_discount()) # from the class level variable

shopping_instance_2 = shopping("Bottle",1000,7)
shopping_instance_2.discount_rate = 0.3
print("Price After Discount:",shopping_instance_2.after_applying_discount()) # dynamically modifying (making fool) the class level variable 


# To return all the attributes of the class or the instance methods (__dict__)
print("Class level variables:",shopping.__dict__)
print("Instance level variables:",shopping_instance_2.__dict__)

print(shopping.all_instances)

# shopping.load_data()

print(shopping.is_integer([8.0, 9.0, 10.5, 6.0, 12.9, 13.0]))
