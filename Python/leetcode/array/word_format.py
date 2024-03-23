#You are given  words. Some words may repeat. For each word, output its number of occurrences. The output order should correspond with the input order of appearance of the word. See the sample input/output for clarification.

def word_format(word):
    word_input = []
    visited = []
    counted = []
    for i in range(word):
        lists = str(input())
        word_input.append(lists)
    for n in range(len(word_input)):
        visited.append(False)
    for j in range(len(word_input)):
        if visited[j]:
            continue
        count = 0
        for k in range(len(word_input)):
            if word_input[j] == word_input[k]:
                count = count + 1
                visited[k] = True
        counted.append(count)
    print(len(counted))
    print(*counted, sep=" ")

words = int(input())
word_format(words)


#Input
#4
#[bcdef, abcdefg, bcde, bcdef]
#output:
#3
#2 1 1
