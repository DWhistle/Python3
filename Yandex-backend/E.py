inp = input()



def blank_spaces(string):
    it = 0
    blank = [0, 0]
    while (it < len(string)):

        if string[it] != '}' and string[it] != '{':
            blank +=
        if string[it] == '}' and blank == 0:
            return 1
        else:
            return blank
        if string[it] == '{':
            blank += blank_spaces(string[:it])