#If 1st day of year i,e January is Monday then what is 200th day


def find_day(num, start):
    week = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
    for i in range(len(week)):
        if week[i] == start:
            temp = i
            break
    index = num % 7
    print(week[index+temp])

num = 200
start = 'tue'
find_day(num, start)
