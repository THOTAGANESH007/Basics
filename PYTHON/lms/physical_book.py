from book import Book

class PhysicalBook(Book):
    def get_loan_period(self):
        return 14  # days
