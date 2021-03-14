# RapidMatch

## Getting started

Grab [RapidMatch](https://vldb.org/pvldb/vol14/p176-sun.pdf) and build it:

```bash
git clone --branch tsmb https://github.com/szarnyasg/RapidMatch/
cd RapidMatch && mkdir build && cd build && cmake .. && make
```

Run it as follows:

```bash
${RAPIDMATCH_DIR}/RapidMatch/build/matching/RapidMatch.out \
  -d data_graph/ldbc.graph  \
  -q query_graph/person_triangle.graph
  -order nd \
  -time_limit 300 \
  -preprocess true
```

## Generating data

First, load the desired data set to DuckDB in this repository.

```bash
export SF=example
cd ddb
./load.sh
cd ..
```

Then, run:

```bash
cat rdm/conv.sql | sed "s/SCALE_FACTOR/${SF}/g" | ddb/scratch/duckdb ddb/scratch/ldbc.duckdb
```
