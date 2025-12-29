from book import Book

class EBook(Book):
    def get_loan_period(self):
        return 7  # days (shorter loan)
