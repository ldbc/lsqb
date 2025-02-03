import os
import pandas as pd
import csv

# Load the expected output file
expected_output_path = '../expected-output/expected-output.csv'
results_path = '../results/results.csv'

# Load expected output, handling potential formatting issues
expected_df = pd.read_csv(expected_output_path, sep='\t', skiprows=8, header=None)
expected_df.columns = ['System', 'Threads', 'ScaleFactor', 'Query', 'Execution Time', 'Expected_Result']

# Clean expected output
expected_df = expected_df.dropna(subset=['Query', 'Expected_Result'])
expected_df['Query'] = expected_df['Query'].astype(str)
expected_df['ScaleFactor'] = expected_df['ScaleFactor'].astype(str)
expected_df['Expected_Result'] = pd.to_numeric(expected_df['Expected_Result'], errors='coerce')

# Load the results file
results_df = pd.read_csv(results_path, sep='\t')
results_df['Query'] = results_df['Query'].astype(str)
results_df['ScaleFactor'] = results_df['ScaleFactor'].astype(str)
results_df['Results'] = pd.to_numeric(results_df['Results'], errors='coerce')

# Merge the DataFrames on Query and ScaleFactor to compare results
comparison_df = pd.merge(results_df, expected_df, on=['Query', 'ScaleFactor'], how='inner', suffixes=('_actual', '_expected'))

# Identify mismatches between actual and expected results
mismatches = comparison_df[comparison_df['Results'] != comparison_df['Expected_Result']]

# Output mismatches if any
if not mismatches.empty:
    print("Mismatches found:")
    print(mismatches[['System_actual', 'Query', 'ScaleFactor', 'Results', 'Expected_Result']])
else:
    print("All results match the expected output!")
