#Given an integer array nums, move all 0's to the end of it while maintaining the relative order of the non-zero elements without making copy of that array

def move_zero(num):
    length = len(num)
    count = 0
    for i in range(length):
        if num[i] != 0:
            num[count] = num[i]
            count = count + 1
    while count < length:
        num[count] = 0
        count = count + 1
    return num

nums = [1,2,3,0,4,0,0,5]
print(move_zero(nums))

#Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].


def product(num):
    answer = []
    for i in range(len(num)):
        prd = 1
        for j in range(len(num)):
            if i != j:
                prd = prd * num[j]
        answer.append(prd)
    return answer

nums = [1,2,3,3]
print(product(nums))


#Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

def target(num,k):
    flag = True
    for i in range(len(num)):
        if flag:
            for j in range(i+1,len(num)):
                if num[i] + num[j] == k:
                    return i,j
                    flag = False

nums = [2,7,11,15]
k=9
print(target(nums,k))
