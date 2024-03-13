def rev_string(rev):
    reverse = ""
    for c in rev:
        reverse = c + reverse
    return reverse

str = "hello"
print("Reverse string is:", rev_string(str))