import sys
import time

from common import VERSION, command

if len(sys.argv) < 2:
    print("Usage: client.py sf <system variant>")
    print("Where sf is the scale factor and the system variant is a free-form label (e.g. community)")
    exit(1)

sf = sys.argv[1]
system_variant = sys.argv[2] if len(sys.argv) > 2 else ""

with open("results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        print(f"Query {i}")
        with open(f"cypher/q{i}.cypher", "r") as query_file:
            query = query_file.read().strip()
        start = time.time()
        result = command(query, language="opencypher")["result"][0]
        duration = time.time() - start
        results_file.write(f"ArcadeDB-{VERSION}\t{system_variant}\t{sf}\t{i}\t{duration:.4f}\t{result['count']}\n")
        results_file.flush()
