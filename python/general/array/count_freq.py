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
