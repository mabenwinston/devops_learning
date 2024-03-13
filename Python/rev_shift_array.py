def reverse_array(arr):
    i = 0
    j = len(arr) - 1
    while i < j:
        temp = arr[i]
        arr[i] = arr[j]
        arr[j] = temp
        i = i+1
        j = j-1
    return arr

arr = [1,2,3,4,5]
print(reverse_array(arr))



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


