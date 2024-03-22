def bubble_sort(n):
    sorted = []
    length = len(n)
    while length > 0:
        min = n[0]
        for i in n:
            if i < min:
                min = i
        n.remove(min)
        sorted.append(min)
        length = length - 1
    return sorted

nums = [5, 2, 8, 1, 9,3]
print(bubble_sort(nums))

