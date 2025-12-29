from datetime import datetime, timedelta

class Transaction:
    def __init__(self, book, member):
        self.book = book
        self.member = member
        self.issue_date = datetime.now()
        self.due_date = self.issue_date + timedelta(days=book.get_loan_period())
        self.return_date = None

    def return_book(self):
        self.return_date = datetime.now()

    def __str__(self):
        return (
            f"Book: {self.book.title}, "
            f"Member: {self.member.name}, "
            f"Due: {self.due_date.date()}, "
            f"Returned: {self.return_date.date() if self.return_date else 'No'}"
        )