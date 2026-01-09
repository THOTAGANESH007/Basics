# imports
from abc import ABC, abstractmethod

# Singleton ensures that a class has only one instance and provides a global access point to it.
# The object is shared globally
# Examples: Database connection pool, Logger, Configuration manager, Cache manager

class Singleton:
    _instance = None
    
    def __new__(cls): # class method
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
    

test1 = Singleton()
print(test1)
test2 = Singleton()
print(test2)

# Factory Pattern provides an interface for creating objects, but lets subclasses or logic decide which class to instantiate.
# me: give the object, factory: which one

# Product
class Payment(ABC):
    @abstractmethod
    def pay(self, amount):
        pass

# Concrete Products
class CreditCard(Payment):
    def pay(self, amount):
        print(f"{amount} Amount paid through the {self.__class__.__name__}")
        
class UPI(Payment):
        def pay(self, amount):
            print(f"{amount} Amount paid through the {self.__class__.__name__}")
class Cash(Payment):
        def pay(self, amount):
            print(f"{amount} Amount paid through the {self.__class__.__name__}")

# Creating a Factory

class PaymentFactory():
    def __init__(self, amount: int, payment: Payment):
         self.amount = amount
         self.payment = payment
    def get_payment(self):
        return self.payment.pay(self.amount)
    
# Creating the object

try:
    amount = int(input("Enter Amount: "))
    if amount < 0:
        raise Exception("Amount Should not be negative")
    if not isinstance(amount,int):
        raise Exception("Please Enter a number")
    
    upi = UPI()
    payment_factory = PaymentFactory(amount,upi)
    payment_factory.get_payment()
except Exception as e:
    print(e)
    
