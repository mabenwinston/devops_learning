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

def max_profit(prices):
    max_profit = 0
    for i in range(1, len(prices)):
        if prices[i] > prices[i - 1]:
            max_profit = max_profit + prices[i] - prices[i - 1]
    return max_profit

# prices = [1,2,3,4,5]
# prices = [7,1,5,3,6,4]
prices = [7,6,4,3,1]
print("Output:", max_profit(prices))


def rotate(nums):
    max = len(nums)
    temp = nums[0]
    for i in range(max - 1):
        nums[i] = nums[i + 1]
    nums[max - 1] = temp
    return nums

nums = [1, 2, 3, 4, 5, 6, 7]
print(rotate(nums))



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