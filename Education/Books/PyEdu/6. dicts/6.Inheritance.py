class NamedList(list):
    def __init__(self, name):
        list.__init__([])
        self.name = name



class AthList(list):
    def __init__(self, name:str, dob:str = None, stats:list = []) -> None:
        self.name = name
        list.__init__([])
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

johny = NamedList("John")

print(dir(johny))

johny.append("Player")
johny.extend(["Composer", "Musician"])
print(johny)

for attr in johny:
    print(attr)


    