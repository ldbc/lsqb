# Typed Subgraph Matching Benchmark

[![Build Status](https://circleci.com/gh/ldbc/tsmb.svg?style=svg&circle-token=b558369d54d3205fc9d985a4dd2196b967ebcff8)](https://circleci.com/gh/ldbc/tsmb)

A benchmark for subgraph matching but with types information (edge types, mostly). The primary goal of this benchmark is to test the query optimizer (join ordering, choosing between binary and n-ary joins) and the execution engine (join performance, support for worst-case optimal joins) of graph databases. Features found in more mature database systems and query languages such as date/string operations, query composition, complex aggregates/filters are out of scope for this benchmark.

* [Presentation](https://docs.google.com/presentation/d/1pxyX_CWhFVYEttjTG2BrzuaMkEuLRxfhf5iX6n0leZI/edit)
* [Design Doc](https://docs.google.com/document/d/1w1cMNyrOoarG69fmNDr5UV7w_T0O0j-yZ0aYu29iWw8/edit)
* [VLDB'19 keynote by Tamer Özsu](https://vldb2019.github.io/files/VLDB19-keynote-1-slides.pdf)
## Getting started

### Install dependencies

```bash
scripts/install-dependencies.sh
```

### Creating the input data

#### Preprocess the data

Run the following script which preprocesses the example data set files and places the CSVs under `data/social-network-${SF}-preprocessed`, where `${SF}` can take the value of e.g. `sf10`.

```bash
scripts/preprocess.sh ${DATAGEN_DATA_DIR}
```

It is possible to run this script without arguments. In this case, it preprocesses the CSV files representing the [LDBC SNB example graph](https://ldbc.github.io/ldbc_snb_docs/example-graph-without-refreshes.pdf), stored in this repository in `data/example-graph`.

```bash
scripts/preprocess.sh
```

#### Using SF0.003 data set

We provide the SF0.003 data set for testing. This data set is preprocessed. To use it, run:

```bash
rm -rf data/social-network-preprocessed/*
cp -r data/social-network-sf0.003-preprocessed/* data/social-network-preprocessed
```

#### Generating larger data sets

1. Run the latest Datagen.

1. Use the scripts in the [converter](https://github.com/ldbc/ldbc_snb_data_converter) repository:

   Drop the `bulkLoadTime` filters from the SQL script, then:

   ```bash
   ./spark-concat.sh ${DATAGEN_DATA_DIR} && ./proc.sh ${DATAGEN_DATA_DIR} --no-header && ./rename.sh
   export CONVERTER_REPOSITORY=`pwd`
   ```

1. In this repository, preprocess and load to Neo4j to validate:

   ```bash
   scripts/preprocess.sh ${CONVERTER_REPOSITORY}/data/csv-composite-projected-fk-legacy-filenames && neo/load.sh
   ```

### Running the benchmark

The following implementations are provided.

Stable implementations:

* `neo`: [Neo4j Community Edition](https://neo4j.com/) (containerized)
* `ddb`: [DuckDB](https://www.duckdb.org/) (bare metal)
* `pos`: [PostgreSQL](https://www.postgresql.org/) (containerized)
* `umb`: [Umbra](https://umbra-db.com/) (can run bare-metal but needs a very recent distribution, e.g. Fedora 33+)

WIP implementations:

* `mem`: [Memgraph](https://memgraph.com/) (containerized)
* `red`: [RedisGraph](https://oss.redislabs.com/redisgraph/) (?)
* `dgr`: [Dgraph](https://dgraph.io/) (containerized)

Planned implementations:

* `kat`: Katana Graph (Cypher)
* `grf`: Graphflow (Cypher)
* `rai`: RelationalAI (Rel)
* `pgx`: Oracle PGX (PGQL)
* `tgr`: TigerGraph (GSQL)

:warning: Both Neo4j and Memgraph use the Bolt protocol for communicating with the client.
To avoid clashing on port `7687`, the Memgraph instance uses port `27687` for its Bolt communication.
Note that the two systems use different Bolt versions so different client libraries are necessary.

#### Populating the database with data

Some systems need to be online before loading, while others need to be offline. To handle these differences in a unified way, we use 4 commands:

* `pre-load.sh`: steps before loading the data (e.g. starting the DB for systems with online loaders)
* `load.sh`: loads the data
* `post-load.sh`: steps after loading the data (e.g. starting the DB for systems with offline loaders)
* `run.sh`: runs the benchmark 

Example usage:

```bash
cd neo
./pre-load.sh & ./load.sh & ./post-load.sh & ./run.sh
```

The vanilla `load.sh` scripts load the data `data/social-network-preprocessed`. To load the data from another directory, use `load.sh <PATH_TO_DIR>`.

## Philosophy

* This benchmark has been inspired by the [LDBC SNB](https://arxiv.org/pdf/2001.02299.pdf) and the [JOB](https://db.in.tum.de/~leis/papers/lookingglass.pdf) benchmarks.
* This benchmark is designed to be *simple* similarly to the [TPC-x "Express" benchmarks](http://www.vldb.org/pvldb/vol6/p1186-nambiar.pdf).
In the spirit of this, we do not provide auditing guidelines – it's the user's responsibility to ensure that the benchmark setup is meaningful.
