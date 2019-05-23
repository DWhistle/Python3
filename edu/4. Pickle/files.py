import os
import pickle

man = []
other = []
try:
    with open("sketch.txt") as the_file:
        for data in the_file:
            try:
            #if data.find(':') != -1:
                (role, line_spoken) = data.split(":",1)
                line_spoken = line_spoken.strip()
                if role == 'Man':
                    man.append(line_spoken + '\n')
                elif role == 'Other Man':
                    other.append(line_spoken)
            # print("Role:", role, end=' ')
            # print("Said: ", line_spoken, end ='')
            except ValueError:
                pass
    #print("the end", file=the_file)
        the_file.close()
        print(man, end='\n\n')
        print(other)
except IOError as err:
    print('No file: ' + str(err))

try:
    with open("input.txt", "w+") as file_input, open("other.txt", "w") as other_file:
        print(man, file=file_input)
        print(other, file =other_file)
        file_input.seek(0)
except:
    print("No second file")

# finally:
#     if file_input in locals():
#         file_input.close()
#     if other_file in locals():
#         other_file.close()