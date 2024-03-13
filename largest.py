def largest(num,k):
    while k > 0:
        largest = num[0]
        for i in num:
            if i > largest:
                largest = i
        num.remove(largest)
        k = k - 1
    return largest

numbers = [3,5,68,8,98,44]
k=2
print(largest(numbers,k))
