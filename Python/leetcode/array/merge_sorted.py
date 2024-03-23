def merge_sorted(num1,num2,m,n):
    sum = []
    sorted = []
    length = m+n
    for i in range(m):
        sum.append(num1[i])
    for j in range(n):
        sum.append(num2[j])
    while length > 0:
        small =sum[0]
        for k in sum:
            if k < small:
                small = k
        sorted.append(small)
        sum.remove(small)
        length = length - 1
    return sorted

num1 = [1,2,3,0,0,0]
num2 = [2,5,6]
m = 3
n = 3
print(merge_sorted(num1,num2,m,n)) 