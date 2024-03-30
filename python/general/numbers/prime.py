def prime(num):
    flag = False
    try:
        if num == 1:
            print(f"{num} is not a prime number")

        elif num > 1:
            for i in range(2,num):
                if num % i == 0:
                    print(f"{num} is not a prime number")
                    flag = True
                    break
    except:
        return 1
    
    if flag == False:
        print (f"{num} is a prime number")
    

num = int(input("Enter the number: "))
prime(num)



def find_prime(num1,num2):
    for num in range(num1, num2 + 1):
        if num > 1:
            flag = True
            for i in range(2, num):
                if num % i == 0:
                    flag = False
                    break
            if flag:
                print(num)

num1 = 1
num2 = 10
find_prime(num1,num2)