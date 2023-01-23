import duckdb
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--system', nargs='+', type=str, required=True)
parser.add_argument('--variant', nargs='+', type=str)
parser.add_argument('--scale_factor', type=str, required=True)
args = parser.parse_args()

system = ' '.join(args.system)
variant = '' if args.variant is None else ' '.join(args.variant)
scale_factor = args.scale_factor

print(f"Cross-validating results for system '{system}', variant '{variant}', scale factor '{scale_factor}'")

#con = duckdb.connect(database=':memory:')
con = duckdb.connect(database='/tmp/my.duckdb')
con.execute(f"""
    CREATE OR REPLACE TABLE results (
        system STRING NOT NULL,
        variant STRING,
        scale_factor STRING NOT NULL,
        query INT,
        time FLOAT,
        result LONG
    )
    """)

con.execute(f"COPY results FROM 'results/results.csv'                 (DELIMITER '\t', HEADER false, FORMAT csv, NULL 'xxx')")
con.execute(f"COPY results FROM 'expected-output/expected-output.csv' (DELIMITER '\t', HEADER false, FORMAT csv, NULL 'xxx')")

con.execute(f"""
    SELECT count(*) AS numResults
    FROM results actual
    WHERE actual.system = '{system}'
      AND actual.scale_factor = '{scale_factor}'
      AND actual.variant = '{variant}'
    """)
numResults = con.fetchone()[0]

if numResults == 0:
    print("Cross-validation failed: no results found.")
    exit(1)

con.execute(f"""
    SELECT expected.query AS query, expected.result AS expectedResult, actual.result AS actualResult
    FROM results expected, results actual
    WHERE expected.system = 'expected'
      AND actual.system = '{system}'
      AND actual.scale_factor = '{scale_factor}'
      AND actual.variant = '{variant}'
      AND actual.scale_factor = expected.scale_factor
      AND actual.query = expected.query
      -- return rows where the results do not match up 
      AND actual.result != expected.result
    """)
crossValResults = con.fetchall()
if len(crossValResults) == 0:
    print("Cross-validation passed: the results are identical.")
