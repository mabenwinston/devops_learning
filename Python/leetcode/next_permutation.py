#Given an array arr[] of size N, the task is to print the lexicographically next greater permutation of the given array. 
#If there does not exist any greater permutation, then print the lexicographically smallest permutation of the given array.
#For example, for arr = [1,2,3], the following are all the permutations of arr: [1,2,3], [1,3,2], [2, 1, 3], [2, 3, 1], [3,1,2], [3,2,1].


def next_perm(arr):

    length = len(arr)
    for i in range(length-2,-1,-1):
        if arr[i] < arr[i+1]:
            break
    if i > 0:
        for j in range(length-1,i,-1):
            if arr[i] < arr[j]:
                break

        temp = arr[i]
        arr[i] = arr[j]
        arr[j] = temp
    
        n = i+1
        m = length -1
        while n < m:
            temp = arr[n]
            arr[n] = arr[m]
            arr[m] = temp
            n = n+1
            m = m-1
    else:
        return arr[::-1]

    return arr

#arr = [1, 2, 3, 6, 5, 4]
arr = [3,2,1]
print(next_perm(arr))



