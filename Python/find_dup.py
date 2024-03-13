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
