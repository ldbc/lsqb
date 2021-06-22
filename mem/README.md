# Memgraph client

To create headerless CSV files, navigate to the data set directory (e.g. `../data/social-network-sfexample-projected-fk/`) and run the following command:

```bash
for f in *.csv; do tail -n +2 ${f} > ${f}-headerless; done
```
