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

Label mapping :
```
Person: 0
City: 1
Country: 2
Continent: 3
Forum: 4
Post: 5
Comment: 6
Tag: 7 TODO
TagClass: 8 TODO
```

## Queries

| Query   | Implemented          | Comments |
| ------- | -------------------- | -------- |
| 1       | :x:                  |          |
| 2       | :x:                  |          |
| 3       | :x:                  |          |
| 4       | :white_check_mark:   |          |
| 5       | :white_check_mark:   |          |
| 6       | :x:                  |          |
