# Find the Sum of First N Natural Numbers-----------------------------------------------------------------------
def fact(num):
    n = 1
    sum = 0
    while n < (num + 1):
        sum = sum + n
        n = n + 1
    return sum
num = 2
print("Sum of first N numbers are:", fact(num))


# print sum of N natural numbers-----------------------------------------------------------------------
def sum_num(n):
    sum = 0
    for i in n:
        sum = sum + i
    return sum
numbers = [1,2,6,7]
print("sum of natural number:", sum_num(numbers))
