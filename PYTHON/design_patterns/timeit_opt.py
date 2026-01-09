import timeit

list_comp = timeit.timeit(
    "[i*i for i in range(1000)]",
    number=10000
)

loop = timeit.timeit(
    """
result = []
for i in range(1000):
    result.append(i*i)
""",
    number=10000
)

print("List comprehension:", list_comp)
print("For loop:", loop)


# import timeit

# Another

result = timeit.timeit(
    stmt="sum(range(1000))",
    number=10000
)

print(result)

# timeit → “How fast is this one thing?”