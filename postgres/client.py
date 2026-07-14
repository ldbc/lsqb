import psycopg2
import time
import argparse

args_parser = argparse.ArgumentParser(description="Run LSQB benchmark with a given scale factor")
args_parser.add_argument('--sf', type=str, required=True, help='The scale factor')
args_parser.add_argument('--system', type=str, default='PostgreSQL', help='System')
args_parser.add_argument('--variant', type=str, default='', help='Variant')
args_parser.add_argument('--queries-path', type=str, default='sql', help='Path to LSQB queries')
args = args_parser.parse_args()

def run_query(con, variant, sf, query_id, query_spec, system, results_file):
    start = time.time()
    cur = con.cursor()
    try:
        cur.execute(query_spec)
    except psycopg2.errors.QueryCanceled:
        cur.connection.rollback()
        return
    result = cur.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"{system}\t{variant}\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

if __name__ == "__main__":

    con = psycopg2.connect(
        host="localhost", 
        user="postgres", 
        password="mysecretpassword", 
        port=15432,
        options=f"-c statement_timeout=300000"
    )

    with open(f"results/results.csv", "a+") as results_file:
        for i in range(1, 10):
            with open(f"{args.queries_path}/q{i}.sql", "r") as query_file:
                run_query(con, args.variant, args.sf, i, query_file.read(), args.system, results_file)
