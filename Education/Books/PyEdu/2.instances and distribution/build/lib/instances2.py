def rec(inner_lists):
    for obj in inner_lists:
      if isinstance(obj, list):
        rec(obj)
      else:
        print(obj)

inner_lists = ["1", [2, 3, 4, [5, 6, 7, 8]]]

rec(inner_lists)