# DuckPGQ LSQB implementation

Implementation of the LSQB benchmark using the [DuckPGQ community extension](https://duckdb.org/community_extensions/extensions/duckpgq.html).

1. Set the maximum scale factor with `export MAX_SF=...`
2. Download the projected datasets using the [download script](../scripts/download-projected-fk-data-sets.sh)
3. Set the desired scale factor with `export SF=...`
4. Run [`./init-and-load.sh`](init-and-load.sh)
4. Run [`./run.sh`](run.sh)
5. The benchmark results will be written to [results.csv](../results/results.csv)
6. The results can be validated against the expected using [cross-validate-against-expected.csv](../scripts/cross-validate-against-expected.py). For example:

    ```bash
    scripts/validate.sh --system 'DuckPGQ-1.2.1' --variant '10 threads' --scale_factor 1
    ```
