def move_zero(arr):

    for num in arr:
        if num == 0:
            arr.remove(num)
            arr.append(num)
    return arr

nums= [1,3,0,3,6,0,8]
print("New list is ", move_zero(nums))

