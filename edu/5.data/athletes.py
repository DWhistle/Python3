
def sanitize(item):
    if '.' in item:
        splitter = '.'
    elif '-' in item:
        splitter = '-'
    else:
        return item
    (mins, secs) = item.split(splitter)
   # print(mins, secs)
    return (mins + ':' + secs)


first = []
second = []
third = []
fourth = []
try:
    with open("james.txt") as james, open("julie.txt") as julie, open("mikey.txt") as mikey, open("sarah.txt") as sarah:
        first = james.readline().split(',')
        second = julie.readline().split(',')
        third = mikey.readline().split(',')
        fourth = sarah.readline().split(',')
except IOError as err:
    print("Error " + str(err))
    # print(sorted(first))
    # print(sorted(second))
    # print(sorted(third))å
    # print(sorted(fourth))
    # for item in first:
    #     if '.' in item or '-' in item:
    #         first[first.index(item)] = sanitize(item)
    # for item in second:
    #     if '.' in item or '-' in item:
    #         second[second.index(item)] = sanitize(item)
    # for item in third:
    #     if '.' in item or '-' in item:
    #         third[third.index(item)] = sanitize(item)
    # for item in fourth:
    #     if '.' in item or '-' in item:
    #         fourth[fourth.index(item)] = sanitize(item)
try:
    first = list(set([sanitize(each) for each in first]))
    second = list(set([sanitize(each) for each in second]))
    third = list(set([sanitize(each) for each in third]))
    fourth = list(set([sanitize(each) for each in fourth]))
    dup_first = dup_second = dup_third = dup_fourth = []
    for elem in first:
        if elem not in dup_first:
            dup_first.append(elem)
    print(sorted(first, reverse=True)[0:3])
    print(sorted(second, reverse=True)[0:3])
    print(sorted(third, reverse=True)[0:3])
    print(sorted(fourth, reverse=True)[0:3])


    mins = [1, 2, 3]
    secs = [int(m * 60.2) for m in mins]
    one = ["I'm", "Lower", "CASED"]
    two = [m.lower() for m in one]
    print(secs)
    print(two)
except:
    print("Something went wrong %)")
    # print(dup_first)
