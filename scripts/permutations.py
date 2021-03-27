import numpy as np

perms = []
for i in range(0, 5):
    arr = np.random.permutation(9)
    arr = [x+1 for x in arr]
    perms += arr
    print(arr)

print(perms)
