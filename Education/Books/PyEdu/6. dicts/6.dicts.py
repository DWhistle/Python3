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

def get_coach_data(files):
    try:
        with open(files) as results:
            listing = results.readline().strip().split(',')
            (name, DoB) = listing.pop(0), listing.pop(0)
    except IOError as err:
        print("Error: " + str(err))
        return None
    result = list(set([sanitize(elem) for elem in listing]))
    output = {'Name': name, 'DoB':DoB, 'result':sorted(result, reverse=True)[0:3]}
    return output

# with open("sarah2.txt") as sarah2:
#     sarah = sarah2.readline().strip().split(',')
#     (name, DoB) = sarah.pop(0), sarah.pop(0)
#     # print(name, DoB)
#     sarah = list(set([sanitize(elem) for elem in sarah]))
#     # print(name + "'s best score: ", end="")
#     # print(sorted(sarah, reverse=True)[0:3])


# #DICTIONARIES

cleese = {}
palin = dict()

cleese['Name'] = 'John'
cleese['Occupations'] = ['actor', 'writer']
palin = {'Name': 'Michael', 'Occupations': ['comedian', 'coach']}
palin['Birth-place'] = 'England'
#print(str(cleese) + '\n',palin)
#sarahdict = {'Name': name, 'DoB':DoB, 'Results': sorted(sarah, reverse=True)[0:3]}
#print(sarahdict)
coachdict = get_coach_data("james2.txt")
print(coachdict)