from library import Library
from physical_book import PhysicalBook
from ebook import EBook
from member import Member

lib = Library()

# Add books
lib.add_book(PhysicalBook(1, "Clean Code", "Robert Martin"))
lib.add_book(EBook(2, "Python Crash Course", "Eric Matthes"))

# Add members
lib.add_member(Member(101, "Ganesh"))
lib.add_member(Member(102, "Aravind"))

while True:
    print("\n1. Show Books\n2. Issue Book\n3. Return Book\n4. Exit")
    choice = input("Choose: ")

    if choice == "1":
        lib.show_books()

    elif choice == "2":
        book_id = int(input("Book ID: "))
        member_id = int(input("Member ID: "))
        lib.issue_book(book_id, member_id)

    elif choice == "3":
        book_id = int(input("Book ID: "))
        member_id = int(input("Member ID: "))
        lib.return_book(book_id, member_id)

    elif choice == "4":
        break

    else:
        print("Invalid choice")