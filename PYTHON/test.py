my_dict = {"apple": 1, "banana": 2, "cherry": 3}

# Try to get the value for 'banana'. It will return 2.
value1 = my_dict.get("banana")
print(f"Value for banana is: {value1}")

# Try to get the value for 'orange'. Key not found, so it returns the default value (None).
value2 = my_dict.get("orange")
print(f"Value for orange is: {value2}")

# You can specify a custom default value instead of None
value3 = my_dict.get("mango", "Key Not Found")
print(f"Value for mango is: {value3}")

"""
def search_student():
    roll_number = int(input("Enter Roll Number of the student: "))
    student_name = input("Enter Name of the student: ")
    return (roll_number, student_name)

print(search_student())

"""

# print(dict(zip(["Hello","jkfd","jfh"],["World","fdh"])))
# print(dict("Hello","World"))

l=[1,1,1,1,1,1,1,2,3,4,4,2,2,7,8,6,5]
print(set(l))


from typing import Protocol

# 1. Define the protocol
class FileParser(Protocol):
    def load_data_source(self, path: str, file_name: str) -> str:
        ...
    def extract_text(self, full_file_path: str) -> dict:
        ...

# 2. Implement the protocol in a concrete class without explicit inheritance
class PdfParser:
    """Extract text from a PDF."""
    def load_data_source(self, path: str, file_name: str) -> str:
        # Implementation details...
        return f"Loaded PDF from {path}/{file_name}"

    def extract_text(self, full_file_path: str) -> dict:
        # Implementation details...
        return {"content": "PDF text"}

# A function can now specify that it accepts any object adhering to the FileParser protocol
def process_file(parser: FileParser, path: str, filename: str):
    data = parser.load_data_source(path, filename)
    text = parser.extract_text("full/path/to/file")
    print(f"Processing with: {data}, {text}")

pdf_parser = PdfParser()
process_file(pdf_parser, "/tmp", "doc.pdf")
