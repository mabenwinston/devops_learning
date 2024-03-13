def count_frequency(numbers):
    length = len(numbers)
    visited = []
    for m in range(length):
        visited.append(False)
    for i in range(length):
        if visited[i]:
            continue
        count = 1
        for j in range(i+1,length):
            if numbers[i] == numbers[j]:
                count = count + 1
                visited[j] = True
        print(numbers[i],count)


nums = [1, 2, 3, 2, 1, 3, 2, 4, 5, 4]
print(count_frequency(nums))



def count_frequency(numbers):
    frequency = {}
    for num in numbers:
        if num in frequency:
            frequency[num] += 1
        else:
            frequency[num] = 1
    for key, value in frequency.items():
        print(key, value)

nums = [1, 2, 3, 2, 1, 3, 2, 4, 5, 4]
count_frequency(nums)









# def input_dict():
#     dictionary = {}
#     num_items = int(input("Enter the number of key-value pairs: "))
#     for i in range(num_items):
#         key = input("Enter key: ")
#         value = input("Enter value: ")
#         dictionary[key] = value
#     return dictionary
#
# user_dict = input_dict()
# # print(user_dict)
