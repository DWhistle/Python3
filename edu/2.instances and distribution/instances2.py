def print_lists(inner_lists, level = 0):
    for obj in inner_lists:
      if isinstance(obj, list):
        print_lists(obj, level + 1)
      else:
        for tabs in range(level):
          if level - tabs > 1 and level > -1:
            print("\t", end='')
          else:
            print("\t[", end='')
        print(obj,"]")

inner_lists = ["1", [2, 3, 4, [5, 6, 7, 8]]]

print_lists(inner_lists, 0)