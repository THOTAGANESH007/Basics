def second(x):
    return x[1]

# a = [(1,2), (3,4), (5,6), (7,8)]
a = [(1,2), (2,5), (3,1),(4,15)]
# a.sort(key=second)
a.sort(key= lambda x:x[1])
print(a)


#python script_args.py arg1 arg2 ...

import sys

print(f"Script name: {sys.argv[0]}")
print(f"Arguments: {sys.argv[1:]}")
print(f"Total number of arguments (including script name): {len(sys.argv)}")
