# Typed Subgraph Matching Benchmark

A benchmark for subgraph matching but with types information (edge types, mostly).

Inspired by LDBC SNB and JOB.

[Google Doc](https://docs.google.com/document/d/1w1cMNyrOoarG69fmNDr5UV7w_T0O0j-yZ0aYu29iWw8/edit)

## Getting started

### Preprocess

Run the following script which places the preprocessed CSVs under `data/social_network_preprocessed`:

```bash
scripts/preprocess.sh
```

### Load the data

```bash
scripts/load-neo4j.sh
scripts/load-memgraph.sh
scripts/load-redisgraph.sh
```

## Philoshopy

This is designed to be a simple benchmark. We do not provide auditing guidelines - it's the user's responsibility to ensure that the benchmark setup is meaningful.
