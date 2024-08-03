def fibonacci(num):
    n1=0
    n2=1
    count = 0
    print(n1)
    while num > count:
        print(n2)
        nth = n1 + n2
        n1 = n2
        n2 = nth
        count = count + 1
num=5
fibonacci(num)


def fibonacci(num):
    n1 = 0
    n2 = 1
    fact = []
    for i in range(num):
        fact.append(n1)
        nth = n1 + n2
        n1 = n2
        n2 = nth
    return fact

num=6
print(fibonacci(num))