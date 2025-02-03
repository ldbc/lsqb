import os
import pandas as pd

# Define directories
scale_1_dir = "../data/social-network-sf1-projected"
scale_other_dirs = ["../data/social-network-sf3-projected", "../data/social-network-sf10-projected"]

# Get list of CSV files from scale_1 directory
csv_files = [f for f in os.listdir(scale_1_dir) if f.endswith(".csv")]

for csv_file in csv_files:
    # Read headers from scale_1
    scale_1_path = os.path.join(scale_1_dir, csv_file)
    df_scale_1 = pd.read_csv(scale_1_path, nrows=0)  # Read only the header

    for scale_dir in scale_other_dirs:
        scale_file_path = os.path.join(scale_dir, csv_file)

        if os.path.exists(scale_file_path):
            # Read the existing file, skipping the first row
            df_other = pd.read_csv(scale_file_path, skiprows=1, header=None)

            # Assign correct headers
            df_other.columns = df_scale_1.columns

            # Save the corrected file, overwriting the old one
            df_other.to_csv(scale_file_path, index=False)

            print(f"Updated headers for {scale_file_path}")

print("Header replacement completed!")