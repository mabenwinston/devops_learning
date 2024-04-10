def anagram(str1,str2):
    flag = True
    for i in str1:
        if i not in str2:
            flag = False

    return flag

str1 = "listen"
str2 = "silent"
print(anagram(str1,str2))