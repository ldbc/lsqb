import fileinput
import sys
import re
import os

sf=os.environ.get('SF')
query=os.environ.get('QUERY')

for line in fileinput.input():
    re_embeddings = re.search(r'^#Embeddings: (\d+)$', line)
    if re_embeddings:
        tuples = re_embeddings.group(1)

    re_runtime = re.search(r'Query time \(seconds\): (.+)$', line)
    if re_runtime:
        time = re_runtime.group(1)

print(f"RapidMatch\t\t{sf}\t{query}\t{time}\t{tuples}")
