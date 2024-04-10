def bubble_sort(nums):
    sort = []
    for i in range(len(nums)):
        min = nums[0]
        for j in range(len(nums)):
            if nums[j] < min:
                min = nums[j]
        sort.append(min)
        nums.remove(min)        
    return sort

nums = [5, 2, 8, 1, 9,3]
print(bubble_sort(nums))