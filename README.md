# Typed Subgraph Matching Benchmark

[![Build Status](https://circleci.com/gh/ldbc/tsmb.svg?style=svg&circle-token=b558369d54d3205fc9d985a4dd2196b967ebcff8)](https://circleci.com/gh/ldbc/tsmb)

A benchmark for subgraph matching but with types information (edge types, mostly). The primary goal of this benchmark is to test the query optimizer (join ordering, choosing between binary and n-ary joins) and the execution engine (join performance, support for worst-case optimal joins) of graph databases. Features found in more mature database systems and query languages such as date/string operations, query composition, complex aggregates/filters are out of scope for this benchmark.

* [Presentation](https://docs.google.com/presentation/d/1pxyX_CWhFVYEttjTG2BrzuaMkEuLRxfhf5iX6n0leZI/edit)
* [Design Doc](https://docs.google.com/document/d/1w1cMNyrOoarG69fmNDr5UV7w_T0O0j-yZ0aYu29iWw8/edit)
* [VLDB'19 keynote by Tamer Özsu](https://vldb2019.github.io/files/VLDB19-keynote-1-slides.pdf)
## Getting started

### Install dependencies

1. Install Docker on your machine.

1. Install the required dependencies:

   ```bash
   scripts/install-dependencies.sh
   ```

1. (Optional) Add the Umbra binaries as described in the `umb/README.md` file.

1. (Optional) "Warm up" the system using `scripts/benchmark.sh`, e.g. run all systems through the smallest `example` data set. This should fill Docker caches.

1. (Optional) Copy the data sets to the server. To **decompress and delete** them, run:

   ```bash
   for f in social-network-sf*.tar.zst; do echo ${f}; tar -I zstd -xvf ${f}; rm ${f}; done
   ```

### Creating the input data

Data sets should be provided in two formats:

* `data/social-network-sf${SF}-projected-fk`: projected foreign keys, the preferred format for most graph database management systems.
* `data/social-network-sf${SF}-merged-fk`: merged foreign keys, the preferred format for most relational database management systems.

An example data set is provided with the substitution `SF=example`:

* `data/social-network-sfexample-projected-fk`
* `data/social-network-sfexample-merged-fk`

#### Generating the data sets

1. Run the latest [Datagen](https://github.com/ldbc/ldbc_snb_datagen/) using CSV outputs and mode, e.g. for SF0.3:

   ```bash
   ./tools/run.py ./target/ldbc_snb_datagen-0.4.0-SNAPSHOT.jar -- --format csv --mode raw --scale-factor 0.3
   ```

1. Use the scripts in the [converter](https://github.com/ldbc/ldbc_snb_data_converter) repository:

   ```bash
   cd out/csv/raw/composite_merge_foreign/
   export DATAGEN_DATA_DIR=`pwd`
   ```

1. Go to the [data converter repository](https://github.com/ldbc/ldbc_snb_datagen/):

   ```bash
   ./spark-concat.sh ${DATAGEN_DATA_DIR}
   ./proc.sh ${DATAGEN_DATA_DIR} --no-header
   cat snb-export-only-ids-projected-fk.sql | ./duckdb ldbc.duckdb
   cat snb-export-only-ids-merged-fk.sql    | ./duckdb ldbc.duckdb
   ```

1. Copy the generated files:

   ```bash
   export SF=1
   cp -r data/csv-only-ids-projected-fk/ ~/git/snb/tsmb/data/social-network-sf${SF}-projected-fk
   cp -r data/csv-only-ids-merged-fk/    ~/git/snb/tsmb/data/social-network-sf${SF}-merged-fk
   ```
### Running the benchmark

The following implementations are provided.

Stable implementations:

* `neo`: [Neo4j Community Edition](https://neo4j.com/) [Cypher] (containerized)
* `ddb`: [DuckDB](https://www.duckdb.org/) [SQL] (bare metal)
* `pos`: [PostgreSQL](https://www.postgresql.org/) [SQL] (containerized)
* `mys`: [MySQL](https://www.mysql.com/) [SQL] (containerized)
* `umb`: [Umbra](https://umbra-db.com/) [SQL] (containerized)
* `red`: [RedisGraph](https://oss.redislabs.com/redisgraph/) [Cypher] (containerized)

WIP implementations:

* `mem`: [Memgraph](https://memgraph.com/) [Cypher] (containerized)
* `dgr`: [Dgraph](https://dgraph.io/) [DQL] (containerized)
* `pgx`: [Oracle PGX](https://www.oracle.com/middleware/technologies/parallel-graph-analytix.html) [PGQL]
* `tgr`: [TigerGraph](https://www.tigergraph.com/) [GSQL]

Planned implementations:

* `kat`: [Katana Graph](https://katanagraph.com/) [Cypher]
* `grf`: [Graphflow](http://graphflow.io/) [Cypher]
* `rai`: [RelationalAI](https://relational.ai/) [Rel]

:warning: Both Neo4j and Memgraph use the Bolt protocol for communicating with the client.
To avoid clashing on port `7687`, the Memgraph instance uses port `27687` for its Bolt communication.
Note that the two systems use different Bolt versions so different client libraries are necessary.

#### Populating the database with data

Some systems need to be online before loading, while others need to be offline. To handle these differences in a unified way, we use 4 commands:

* `pre-load.sh`: steps before loading the data (e.g. starting the DB for systems with online loaders)
* `load.sh`: loads the data
* `post-load.sh`: steps after loading the data (e.g. starting the DB for systems with offline loaders)
* `run.sh`: runs the benchmark 
* `stop.sh`: stops the database

Example usage for scale factor 0.3:

```bash
cd neo
export SF=0.3
./pre-load.sh && ./load.sh && ./post-load.sh && ./run.sh && ./stop.sh
```

## Philosophy

* This benchmark has been inspired by the [LDBC SNB](https://arxiv.org/pdf/2001.02299.pdf) and the [JOB](https://db.in.tum.de/~leis/papers/lookingglass.pdf) benchmarks.
* This benchmark is designed to be *simple* similarly to the [TPC-x "Express" benchmarks](http://www.vldb.org/pvldb/vol6/p1186-nambiar.pdf).
In the spirit of this, we do not provide auditing guidelines – it's the user's responsibility to ensure that the benchmark setup is meaningful. We do not provide a common Java/Python driver component as the functionality required by the driver is very simple and can be implemented by users ideally in less than an hour.
