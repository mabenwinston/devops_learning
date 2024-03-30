def swap(num1,num2):
    sum = num1 + num2
    num1 = sum - num1
    num2 = sum - num2
    print("num1=",num1,"num2=", num2)

num1 = 23
num2 = 43
swap(num1,num2)