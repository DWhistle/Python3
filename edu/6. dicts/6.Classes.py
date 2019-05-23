
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
    output = {'Name': name, 'DoB':DoB, 'result':sorted(result, reverse=True)}
    return output

stats = get_coach_data("julie2.txt")

#CLASSES

class Athlete:
    def __init__(self, name:str, dob:str = None, stats:list = []) -> None:
        self.name = name
        self.dob = dob
        self.stats = stats
    def __repr__(self) -> str:
        return(self.name)
    def top(self, i:int = 1) -> list:
        return(self.stats[0:i])
    def add_time(self, time:list= None) -> None:
        if time and isinstance(time,str):
            self.stats.append(time)
        else:
            self.stats.extend(time)
    def arrange(self) -> None:
        self.stats = sorted(self.stats, reverse=True)


Julie = Athlete(stats['Name'], stats['DoB'], stats['result'])


#print(Julie.name + "sth", Julie.dob, Julie.stats)
#print(Julie.top3())
print(Julie.top())
Julie.add_time("5:50")
print(Julie.stats)
print(Julie)