import os
import csv
import duckdb

# List of scale factors (adjustable for different scales)
SF = [1, 3, 10]

# Define base directory and construct paths dynamically
base_dir = "../data/social-network-sf{}-projected"
scale_dirs = [base_dir.format(sf) for sf in SF]

# Load headers from projected-headers.csv into a dictionary
headers_dict = {}
with open("projected-headers.csv", mode='r') as header_file:
    reader = csv.DictReader(header_file)
    for row in reader:
        file_name = row["file"]
        headers = row["headers"].split(";")  # Assuming headers were joined with ';' in the previous script
        headers_dict[file_name] = headers

# Initialize DuckDB connection (in-memory)
conn = duckdb.connect(database=':memory:')

# Process each directory and apply correct headers
for scale_dir in scale_dirs:
    csv_files = [f for f in os.listdir(scale_dir) if f.endswith(".csv")]

    for csv_file in csv_files:
        # Get correct headers from the dictionary
        if csv_file not in headers_dict:
            print(f"Skipping {csv_file} as no headers found in projected-headers.csv")
            continue

        correct_headers = headers_dict[csv_file]
        scale_file_path = os.path.join(scale_dir, csv_file)

        if os.path.exists(scale_file_path):
            # Read CSV without headers, skipping the first row
            conn.execute(f"""
                CREATE OR REPLACE TEMPORARY TABLE temp_table AS 
                SELECT * 
                FROM read_csv_auto('{scale_file_path}', header=False, skip=1)
            """)

            # Apply correct headers
            columns = ", ".join([f"column{i} AS {header}" for i, header in enumerate(correct_headers[0].split("|"))])
            conn.execute(f"""
                CREATE OR REPLACE TEMPORARY TABLE corrected_table AS 
                SELECT {columns}
                FROM temp_table
            """)

            # Overwrite the original file with corrected headers
            conn.execute(f"""
                COPY corrected_table TO '{scale_file_path}' (HEADER, DELIMITER ',')
            """)

            print(f"Updated headers for {scale_file_path}")

print("Header replacement completed!")