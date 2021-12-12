import xgt
import time
import sys
import os

def run_query(connection, query, max_retry = 5):
    """
    Run a query, waiting for it to complete, and return a tuple with these
    items: (data, job)

    If the query fails to complete (e.g., it rolls back), retry up to
    max_retry times.

    If the data is a single row and a single column, return the data as a scalar,
    otherwise return it as a list of lists (array of arrays).
    """
    retry = 0
    while (True):
        try:
            job = connection.run_job(query)
            data = job.get_data()
            if data is not None and len(data) == 1 and len(job.schema) == 1:
                datum = data[0][0]
                if job.schema[0][1] == xgt.INT:
                    return (int(datum), job)
                elif job.schema[0][1] == xgt.FLOAT:
                    return (float(datum), job)
                else:
                    return (str(datum), job)
            return (data, job)
        except xgt.XgtTransactionError:
            if retry >= max_retry:
                raise
            retry += 1

conn = xgt.Connection()
conn.set_default_namespace("lsqb")
if len(sys.argv) < 2:
    print("Usage: client.py sf")
    print("where sf is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]

with open(f"results/results.csv", "a+") as results_file:
    for query_id in range(1, 10):
        with open(f"xgt/queries/q{query_id}.cypher", "r") as query_file:
            query_specification = query_file.read()
            start = time.time()
            result = run_query(conn, query_specification, 1)
            end = time.time()
            duration = end - start

            # compute the sum of the counts for union all queries
            if isinstance(result[0], list):
                result = result[0][0][0] + result[0][1][0]
            else:
                result = result[0]

            print(f"Trovares xGT\t\t{sf}\t{query_id}\t{duration:.4f}\t{result}")
            results_file.write(f"Trovares xGT\t\t{sf}\t{query_id}\t{duration:.4f}\t{result}\n")
            results_file.flush()
