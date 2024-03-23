def left_shift(a,k):
    length = len(a)
    for i in range(k):
        first = a[0]
        a.remove(a[0])
        a.append(first)
    return a
a = [1,2,3,4,5,6]
k=3
print(left_shift(a,k))




def right_shift(a,k):
    length = len(a)
    new = []
    j = 0
    while k > 0:
        m = a[(length - j) -k]
        a.remove(a[(length - j) -k])
        new.append(m)
        j = j + 1
        k = k - 1
    for i in a:
        new.append(i)
    return new
a = [1,2,3,4,5,6,7]
k=3
print(right_shift(a,k))


def rotate(nums):
    max = len(nums)
    temp = nums[0]
    for i in range(max - 1):
        nums[i] = nums[i + 1]
    nums[max - 1] = temp
    return nums

nums = [1, 2, 3, 4, 5, 6, 7]
print(rotate(nums))
