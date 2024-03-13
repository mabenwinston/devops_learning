def palindrome(number):
    temp = number
    reverse = 0
    while temp > 0:
        remainder = temp % 10
        reverse = (reverse * 10) + remainder
        temp = temp // 10
    if reverse == number:
        print("The given number is palindrome")
    else:
        print("The given number is not palindrome")
    return reverse

num = 2234
palindrome(num)