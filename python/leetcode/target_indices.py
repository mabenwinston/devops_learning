
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