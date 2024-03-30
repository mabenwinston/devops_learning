def sec_lar(num):
    n = 0
    while n < 2:
        largest = num[0]
        for i in num[1:]:
            if i == largest:
                num.remove(i)
            elif i > largest:
                largest = i
        num.remove(largest)
        n = n + 1
    return largest

def third_lar(num):
    n = 0
    while n < 3:
        largest = num[0]
        for i in num:
            if i > largest:
                largest = i
        num.remove(largest)
        n = n + 1
    return largest


def smallest(num):
    m = 1
    while m < 4:
        n = num[0]
        for i in num:
            if i < n:
                small = i
            else:
                small = n
        num.remove(small)
        m = m + 1
    return small



arr = [-1000,-78,-56,-12,-54,-100]
arr2 = [1000,78,56,12,54,100]
arr3 = [23,45,56,78,90,12,34,100]
print("Second largest value:", sec_lar(arr))
print("Third largest value:", third_lar(arr2))
print("Smallest value:", smallest(arr3))