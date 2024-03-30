def max_profit(prices):
    max_profit = 0
    for i in range(len(prices)-1):
        if prices[i + 1] > prices[i]:
            max_profit = max_profit + prices[i + 1] - prices[i]
    return max_profit

# prices = [1,2,3,4,5]
prices = [7,1,5,3,6,4]
#prices = [7,6,4,3,1]
print("Output:", max_profit(prices))


def max_profit2(prices):
    buy = prices[0]
    index = 1
    for i in range(len(prices)-1):
        if prices[i] < buy:
            buy = prices[i]
            index = i
    sell = prices[index]
    for j in range(index,len(prices)):
        if prices[j] > sell:
            sell = prices[j]
    return sell, buy

#price = [1,2,3,4,5]
#price = [7,1,5,3,6,4]
price = [7,6,4,3,1]
print("Output:", max_profit2(price))