import os
# Open a file in read/write binary mode
with open("sample.txt", "rb+") as f:
    # Initial position is 0 (beginning of file)
    print(f"Current position: {f.tell()}")

    # Move the pointer to the 6th byte from the beginning (whence=0 is default)
    '''f.seek(6)
    print(f"Position after seek(6): {f.tell()}") # e.g., 6
    print(f.read(7))

    # Read 10 bytes from the new position
    content = f.read()
    print(f"Read content: {content}")'''
    f.seek(6)
    print(f"Position after seek(6): {f.tell()}") # e.g., 6
    
    # Move the pointer 5 bytes backward from the current position (whence=1)
    f.seek(-5, os.SEEK_CUR)
    print(f"Position after seek(-5, 1): {f.tell()}")

    # Move the pointer to the end of the file (whence=2, offset 0)
    f.seek(0, os.SEEK_END)
    print(f"Position after seek(0, 2): {f.tell()}") # e.g., total file size in bytes
    f.write(b"jkh")
    f.seek(-3, os.SEEK_END)
    
    print(len(f.read()))