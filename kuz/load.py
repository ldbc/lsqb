import kuzu
from os import listdir
from os.path import isfile, join
import logging


def load_schema(conn, lsqb_files):
    pass


def load_lsqb_dataset(conn, sf):
    data_path = f'../data/social-network-sf{sf}-projected-fk'

    lsqb_files = [f for f in listdir(data_path) if isfile(join(data_path, f)) and ".csv" in f]

    load_schema(conn, lsqb_files)

    for lsqb_file in lsqb_files:
        logging.debug(f"Loading {lsqb_file}")
        conn.execute(f"""COPY {lsqb_file[:-4]} from '{join(data_path, lsqb_file)}'""")

    logging.info("Loaded data files")


def main():
    SF = 1

    db = kuzu.database('./scratch/lsqb-database')
    conn = kuzu.connection(db)
    logging.info("Successfully connected")

    load_lsqb_dataset(conn, SF)


if __name__ == "__main__":
    logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s', level=logging.DEBUG)
    main()