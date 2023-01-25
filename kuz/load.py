import kuzu
from os import listdir
from os.path import isfile, join
import logging
import shutil
import sys

def load_schema(conn):
    schema_file = open('kuz/schema.cypher').read().split(';')

    for schema in schema_file:
        print(schema)
        print()

        if schema == "":
            continue
        logging.info(f"Loading schema {schema}")
        conn.execute(f"{schema}")

    logging.info("Loaded schema")

def load_lsqb_dataset(conn, sf):
    data_path = f'data/social-network-sf{sf}-projected-fk'

    lsqb_node_files = [f for f in listdir(data_path) if isfile(join(data_path, f)) and not "_" in f and ".csv" in f]
    lsqb_edge_files = [f for f in listdir(data_path) if isfile(join(data_path, f)) and "_" in f and ".csv" in f]

    load_schema(conn)

    for lsqb_file in lsqb_node_files:
        logging.debug(f"Loading {lsqb_file}")
        conn.execute(f"""COPY {lsqb_file[:-4]} from '{join(data_path, lsqb_file)}' (HEADER=True, DELIM='|')""")

    for lsqb_file in lsqb_edge_files:
        logging.debug(f"Loading {lsqb_file}")
        conn.execute(f"""COPY {lsqb_file[:-4]} from '{join(data_path, lsqb_file)}' (HEADER=True, DELIM='|')""")


    logging.info("Loaded data files")


def main():
    if len(sys.argv) < 1:
        print("Usage: client.py sf")
        print("Where sf is the scale factor)")
        exit(1)
    else:
        sf = sys.argv[1]

    database_file_location = 'kuz/scratch/lsqb-database'
    shutil.rmtree(database_file_location, ignore_errors=True)

    db = kuzu.database('kuz/scratch/lsqb-database')

    conn = kuzu.connection(db)


    logging.info("Successfully connected")

    load_lsqb_dataset(conn, sf)


if __name__ == "__main__":
    logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s', level=logging.DEBUG)
    main()