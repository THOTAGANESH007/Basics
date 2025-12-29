from transaction import Transaction

class Library:
    def __init__(self):
        self.books = {}
        self.members = {}
        self.transactions = []

    def add_book(self, book):
        self.books[book.book_id] = book

    def add_member(self, member):
        self.members[member.member_id] = member

    def issue_book(self, book_id, member_id):
        book = self.books.get(book_id)
        member = self.members.get(member_id)

        if not book or not member:
            print("Invalid book or member ID")
            return

        if not book.is_available:
            print("Book is already issued")
            return

        transaction = Transaction(book, member)
        self.transactions.append(transaction)

        book.is_available = False # move to Issued status
        member.borrow_book(book) # add to the borrow_book list

        print(f"Book issued. Due date: {transaction.due_date.date()}")

    def return_book(self, book_id, member_id):
        for txn in self.transactions:
            if (
                txn.book.book_id == book_id
                and txn.member.member_id == member_id
                and txn.return_date is None
            ):
                txn.return_book() # Returned date
                txn.book.is_available = True # to make it available for the others
                txn.member.return_book(txn.book) # remove from the borrow book
                print("Book returned successfully")
                return

        print("Transaction not found")

    def show_books(self):
        for book in self.books.values():
            status = "Available" if book.is_available else "Issued"
            print(book, "|", status)