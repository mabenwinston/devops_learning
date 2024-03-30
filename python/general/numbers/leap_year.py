def leap_year(year):
    if (year % 400 == 0) & (year % 100 == 0) | (year % 4 == 0) & (year % 100 != 0):
        print(f"{year} is a leap year")
    else:
        print(f"{year} is not a leap year")

year = int(input("Enter the year: "))
leap_year(year)