def subArray(num,k):
    curr_min = 0
    for i in range(len(num)):
        if num[i] >= k:
            return 1
        sum = 0
        min = []
        for j in range(i,len(num)):
            sum = sum + num[j]
            if sum >= k:
                for m in range(i,j+1):
                    min.append(num[m])
                curr_min = len(min)

    return curr_min
end = 5
start = 0
sum = end - start + 1
print(sum)


num = [2,3,1,2,4,3]
num1= [1,1,1,1,1,1,1,1]
num2 = [1,4,4]
k = 7
print(subArray(num,k))