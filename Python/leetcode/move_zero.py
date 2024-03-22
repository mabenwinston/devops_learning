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


def move_zero(arr):

    for num in arr:
        if num == 0:
            arr.remove(num)
            arr.append(num)
    return arr

nums= [1,3,0,3,6,0,8]
print("New list is ", move_zero(nums))
