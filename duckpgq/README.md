## DuckPGQ

1. Download the projected datasets using the [download script](../scripts/download-projected-fk-data-sets.sh) to the `data` folder.
2. Copy the dataset and rename to `social-network-sf${SF}-projected` (without the `fk`)
3. Run [convert_headers.py](convert_headers.py) to ensure the files have the correct headers
4. Tune the scale factors you wish to run in the [run.sh](run.sh) script and the number of threads.
5. Run [./run.sh](run.sh) (`chmod +x run.sh`)
6. The results will be written to [results.csv](../results/results.csv)
7. The results can be verified against the expected using [cross-validate-against-expected.csv](../scripts/cross-validate-against-expected.py)