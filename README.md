# Labelled Subgraph Query Benchmark (LSQB)

[![Build Status](https://circleci.com/gh/ldbc/lsqb.svg?style=svg&circle-token=b558369d54d3205fc9d985a4dd2196b967ebcff8)](https://circleci.com/gh/ldbc/lsqb)

A benchmark for subgraph matching but with types information (edge types, mostly). The primary goal of this benchmark is to test the query optimizer (join ordering, choosing between binary and n-ary joins) and the execution engine (join performance, support for worst-case optimal joins) of graph databases. Features found in more mature database systems and query languages such as date/string operations, query composition, complex aggregates/filters are out of scope for this benchmark.

* [VLDB'19 keynote by Tamer Özsu](https://vldb2019.github.io/files/VLDB19-keynote-1-slides.pdf)
* [CACM'21 technical perspective paper on graphs (preprint)](https://arxiv.org/pdf/2012.06171.pdf)

## Getting started

### Install dependencies

1. Install Docker on your machine.

1. (Optional) Change the location of Docker's data directory ([instructions](https://github.com/ftsrg/cheat-sheets/wiki/Docker#move-docker-data-folder-to-a-different-location)).

1. Install the required dependencies:

   ```bash
   scripts/install-dependencies.sh
   ```

1. (Optional) Install "convenience packages" (e.g. vim, ag, etc.).

   ```bash
   scripts/install-convenience-packages.sh
   ```

1. (Optional) Add the Umbra binaries as described in the `umb/README.md` file.

1. (Optional) "Warm up" the system using `scripts/benchmark.sh`, e.g. run all systems through the smallest `example` data set. This should fill Docker caches.

1. (Optional) Copy the data sets to the server. To **decompress and delete** them, run:

   ```bash
   for f in social-network-sf*.tar.zst; do echo ${f}; tar -I zstd -xvf ${f}; rm ${f}; done
   ```

1. Revise the benchmark settings, e.g. the number of threads for DuckDB.

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
   ./load.sh ${DATAGEN_DATA_DIR} --no-header
   ./transform.sh
   cat export/snb-export-only-ids-projected-fk.sql | ./duckdb ldbc.duckdb
   cat export/snb-export-only-ids-merged-fk.sql    | ./duckdb ldbc.duckdb
   ```

1. Copy the generated files:

   ```bash
   export SF=1
   cp -r data/csv-only-ids-projected-fk/ ~/git/snb/lsqb/data/social-network-sf${SF}-projected-fk
   cp -r data/csv-only-ids-merged-fk/    ~/git/snb/lsqb/data/social-network-sf${SF}-merged-fk
   ```

### Running the benchmark

The following implementations are provided.

Stable implementations:

* `umb`: [Umbra](https://umbra-db.com/) [SQL] :whale:
* `hyp`: [HyPer](https://hyper-db.de/) [SQL] :whale:
* `ddb`: [DuckDB](https://www.duckdb.org/) [SQL] (bare metal)
* `pos`: [PostgreSQL](https://www.postgresql.org/) [SQL] :whale:
* `mys`: [MySQL](https://www.mysql.com/) [SQL] :whale:
* `neo`: [Neo4j Community Edition](https://neo4j.com/) [Cypher] :whale:
* `red`: [RedisGraph](https://oss.redislabs.com/redisgraph/) [Cypher] :whale:
* `mem`: [Memgraph](https://memgraph.com/) [Cypher] :whale:
* `vos`: [Virtuoso Open-Source Edition](http://vos.openlinksw.com/owiki/wiki/VOS) [SPARQL] :whale:
* `rdm`: [RapidMatch](https://github.com/RapidsAtHKUST/RapidMatch) [`.graph`]

WIP implementations:

* `pgx`: [Oracle PGX](https://www.oracle.com/middleware/technologies/parallel-graph-analytix.html) [PGQL]
* `tgr`: [TigerGraph](https://www.tigergraph.com/) [GSQL]
* `rai`: [RelationalAI](https://relational.ai/) [Rel]

Planned implementations:

* `kat`: [Katana Graph](https://katanagraph.com/) [Cypher]
* `grf`: [Graphflow](http://graphflow.io/) [Cypher]
* `avg`: [AvantGraph](http://avantgraph.io/) [?]

:warning: Both Neo4j and Memgraph use the Bolt protocol for communicating with the client.
To avoid clashing on port `7687`, the Memgraph instance uses port `27687` for its Bolt communication.
Note that the two systems use different Bolt versions so different client libraries are necessary.

#### Running the benchmark

The benchmark run consists of two key steps: loading the data and running the queries on the database.

Some systems need to be online before loading, while others need to be offline. To handle these differences in a unified way, we use three scripts for loading:

* `pre-load.sh`: steps before loading the data (e.g. starting the DB for systems with online loaders)
* `load.sh`: loads the data
* `post-load.sh`: steps after loading the data (e.g. starting the DB for systems with offline loaders)

To run the benchmark and clean up after execution, we use two scripts:

* `run.sh`: runs the benchmark 
* `stop.sh`: stops the database

Example usage that loads scale factor 0.3 to Neo4j:

```bash
cd neo
export SF=0.3
./pre-load.sh && ./load.sh && ./post-load.sh && ./run.sh && ./stop.sh
```

Example usage that runs multiple scale factors on DuckDB. Note that the `SF` environment variable needs to be exported.

```bash
cd ddb
export SF
for SF in 0.1 0.3 1; do
   ./pre-load.sh && ./load.sh && ./post-load.sh && ./run.sh && ./stop.sh
done
```

## Philosophy

* This benchmark has been inspired by the [LDBC SNB](https://arxiv.org/pdf/2001.02299.pdf) and the [JOB](https://db.in.tum.de/~leis/papers/lookingglass.pdf) benchmarks.
* First and foremost, this benchmark is designed to be *simple*. In the spirit of this, we do not provide auditing guidelines – it's the user's responsibility to ensure that the benchmark setup is meaningful. We do not provide a common Java/Python driver component as the functionality required by the driver is very simple and can be implemented by users ideally in less than an hour.
