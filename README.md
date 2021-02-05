# Typed Subgraph Matching Benchmark

[![Build Status](https://circleci.com/gh/ldbc/tsmb.svg?style=svg&circle-token=b558369d54d3205fc9d985a4dd2196b967ebcff8)](https://circleci.com/gh/ldbc/tsmb)

A benchmark for subgraph matching but with types information (edge types, mostly). The primary goal of this benchmark is to test the query optimizer (join ordering, choosing between binary and n-ary joins) and the execution engine (join performance, support for worst-case optimal joins) of graph databases. Features found in more mature database systems and query languages such as date/string operations, query composition, complex aggregates/filters are out of scope for this benchmark.

* This benchmark has been inspired by the [LDBC SNB](https://arxiv.org/pdf/2001.02299.pdf) and the [JOB](https://db.in.tum.de/~leis/papers/lookingglass.pdf) benchmark.
* [Design Doc](https://docs.google.com/document/d/1w1cMNyrOoarG69fmNDr5UV7w_T0O0j-yZ0aYu29iWw8/edit)

## Implementations

* [Neo4j](https://neo4j.com/)
* [Memgraph](https://memgraph.com/)
* [RedisGraph](https://oss.redislabs.com/redisgraph/)
* [DuckDB](https://www.duckdb.org/)

## Getting started

### Install dependencies

```bash
scripts/install-dependencies.sh
```

### Creating the input data
### Preprocess the data

Run the following script which preprocesses the example data set files and places the CSVs under `data/social-network-preprocessed`:

```bash
scripts/preprocess.sh ${DATAGEN_DATA_DIR}
```

It is possible to run this script without arguments. In this case, it preprocesses the CSV files representing the [LDBC SNB example graph](https://ldbc.github.io/ldbc_snb_docs/example-graph-without-refreshes.pdf), stored in this repository in `data/example-graph`.

```bash
scripts/preprocess.sh
```

### Using SF0.003 data set

We provide the SF0.003 data set for testing. This data set is preprocessed. To use it, run:

```bash
rm -rf data/social-network-preprocessed
cp -r data/social-network-sf0.003-preprocessed/ data/social-network-preprocessed
```

### Generating larger data sets

1. Run the latest Datagen.

1. Use the scripts in the converter repository:

   ```bash
   ./spark-concat.sh ${DATAGEN_DATA_DIR} && ./proc.sh ${DATAGEN_DATA_DIR} --no-header && ./rename.sh
   ```

1. In this repository, preprocess and load to Neo4j to validate:

   ```bash
   scripts/preprocess.sh ${CONVERTER_REPOSITORY}/data/csv-composite-projected-fk-legacy-filenames && scripts/load-neo.sh
   ```

### Running the benchmark

Both Neo4j and Memgraph use the Bolt protocol for communicating with the client.
To avoid clashing on port `7687`, the Memgraph instance uses port `27687` for its Bolt communication.
Note that the two systems use different versions so different client libraries are necessary.
#### Load the data

The following scripts load the data from `data/social-network-preprocessed:

```bash
scripts/load-neo.sh
scripts/load-mem.sh
scripts/load-red.sh
scripts/load-ddb.sh
```

#### Start the database

Start the databases. Note that DuckDB does not need to be started as a separate process (as it's an embedded database).

```bash
scripts/start-neo.sh
scripts/start-mem.sh
scripts/start-red.sh
```

#### Run the queries

```bash
python3 clients/neo.py
python3 clients/mem.py
python3 clients/red.py
python3 clients/ddb.py
```

## Philosophy

This benchmark is designed to be *simple* similarly to the [TPC-x "Express" benchmarks](http://www.vldb.org/pvldb/vol6/p1186-nambiar.pdf).
In the spirit of this, we do not provide auditing guidelines – it's the user's responsibility to ensure that the benchmark setup is meaningful.
