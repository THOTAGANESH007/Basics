from abc import ABC, abstractmethod

class Book(ABC):
    def __init__(self, book_id, title, author):
        self.book_id = book_id
        self.title = title
        self.author = author
        self.is_available = True

    @abstractmethod # must override in the child classes
    def get_loan_period(self):
        pass

    def __str__(self):
        return f"{self.book_id} | {self.title} by {self.author}"