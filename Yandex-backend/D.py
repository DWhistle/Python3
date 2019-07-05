import re
import sys

line = sys.stdin.readline()[0:-1]

reg_dict = re.compile(r"\{\s*\}")
reg_list = re.compile(r"\[\s*\]")

match_dict = 0
match_list = 0

while True:
    len_dict = len(reg_dict.findall(line))
    line = reg_dict.sub("", line)
    len_list = len(reg_list.findall(line))
    line = reg_list.sub("", line)
    match_dict += len_dict
    match_list += len_list
    if len_dict == 0 and len_list == 0:
        break

print(match_dict, match_list)
