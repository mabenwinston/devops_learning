import numpy as np

def input_matrix(rows, cols):
    matrix = []
    print("Enter the elements of the matrix:")
    for i in range(rows):
        row = []
        for j in range(cols):
            element = int(input(f"Enter element at position ({i+1},{j+1}): "))
            row.append(element)
        matrix.append(row)
    return np.array(matrix)
rows = int(input("Enter the number of rows: "))
cols = int(input("Enter the number of columns: "))
user_matrix = input_matrix(rows, cols)
print("User Matrix:")
print(user_matrix)


def matrix_sum(matrix):
    col_sum = 0
    for i in matrix:
        col_sum = col_sum + i

    for i in matrix:
        row_sum = 0
        for j in i:
            row_sum = row_sum + j
        print(i,row_sum)
    return col_sum

matrix = np.array([[1,2,3],[4,5,6],[7,8,9]])
print(matrix_sum(matrix))









