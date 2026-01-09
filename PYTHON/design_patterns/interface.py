from abc import ABC, abstractmethod

class MyInterface(ABC):
    def __init__(self, name):
        self.name = name
    @abstractmethod
    def greet(self):
        pass
    

class Child(MyInterface):
    def greet(self):
        print(f'Hello {self.name}')
    def hello(self):
        print("hi")

def call_interface(obj:MyInterface):
    # return obj
    # print('hello')
    obj.greet()
    

child = Child("Mango")
child.greet()
print(call_interface(child))