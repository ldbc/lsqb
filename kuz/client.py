import time
import sys
import kuzu
import logging

def run_query(conn, system_variant, sf, query_id, query_spec, results_file):
    start = time.time()
    results = conn.execute(query_spec)
    if results.has_next():
        result = results.get_next()

    end = time.time()
    duration = end - start
    results_file.write(f"KuzuDB\t{system_variant}\t{sf}\t{query_id}\t{duration:.4f}\t{result[0]}\n")
    results_file.flush()
    return (duration, result)


def main():
    if len(sys.argv) < 1:
        print("Usage: client.py sf")
        print("Where sf is the scale factor)")
        exit(1)
    else:
        sf = sys.argv[1]

    db = kuzu.Database('kuz/scratch/lsqb-database')
    conn = kuzu.Connection(db)

    with open(f"results/results.csv", "a+") as results_file:
        for i in range(1, 10):
            print(i)
            with open(f"kuz/q{i}.cypher", "r") as query_file:
                run_query(conn, "", sf, i, query_file.read(), results_file)

if __name__ == "__main__":
    logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s', level=logging.DEBUG)
    main()
