import duckdb
import sys

sf = None
if len(sys.argv) < 2:
    print("Usage: client.py sf [threads]")
    print("where sf is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]

con = duckdb.connect(f'scratch/lsqb-{sf}.duckdb')
con.install_extension("duckpgq", repository="community", force_install=True)
con.load_extension("duckpgq")

data_dir = f"../data/social-network-sf{sf}-projected"
with open("../pgq/snb-load.sql", "r") as f:
    load_query = f.read().replace("PATHVAR", data_dir)
    con.execute(load_query)

con.close()
