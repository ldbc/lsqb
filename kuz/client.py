import time
import sys
import kuzu
import logging

def run_query(conn, sf, query_id, query_spec, results_file, num_threads):
    start = time.time()
    print(query_spec)
    results = conn.execute(query_spec)
    if results.has_next():
        result = results.get_next()

    end = time.time()
    duration = end - start
    results_file.write(f"KuzuDB-{kuzu.__version__}\t{num_threads} threads\t{sf}\t{query_id}\t{duration:.4f}\t{result[0]}\n")
    results_file.flush()
    return (duration, result)


def main():
    if len(sys.argv) < 1:
        print("Usage: client.py sf [threads]")
        print("Where sf is the scale factor)")
        exit(1)
    else:
        sf = sys.argv[1]
    if len(sys.argv) > 2:
        num_threads = int(sys.argv[2])
    else:
        num_threads = 4

    db = kuzu.Database('kuz/scratch/lsqb-database')
    conn = kuzu.Connection(db)
    conn.set_max_threads_for_exec(num_threads)

    with open(f"results/results.csv", "a+") as results_file:
        for i in range(1, 10):
            print(f"Query {i}")
            with open(f"kuz/q{i}.cypher", "r") as query_file:
                run_query(conn, sf, i, query_file.read(), results_file, num_threads)

if __name__ == "__main__":
    logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s', level=logging.DEBUG)
    main()
