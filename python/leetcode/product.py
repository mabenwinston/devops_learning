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