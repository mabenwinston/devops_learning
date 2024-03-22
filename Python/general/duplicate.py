def find_duplicates(arr):
    seen = []
    dup = []
    for num in arr:
        if num not in seen:
            seen.append(num)
        else:
            dup.append(num)
    return dup  

arr = [1, 2, 3, 4, 5, 2, 7, 8, 3]
print("Duplicates in the array:", find_duplicates(arr))



def rem_dup(num):
    sorted = []
    x = len(num)
    for i in num:
        if i not in sorted:
            sorted.append(i)
    print(len(sorted),",", sorted)
    return sorted
nums = [0,0,1,1,1,2,2,3,3,4]
rem_dup(nums)


def duplicate(nums):
    list = []
    temp = ""
    for i in nums:
        if i not in list:
            list.append(i)
        else:
            temp="false"
            break
    if temp == "false":
        print("false")
    else:
        print("true")
    return nums

nums = [1,2,3]
duplicate(nums)