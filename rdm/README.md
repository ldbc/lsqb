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
Tag: 7
TagClass: 8 TODO
```

## Queries

| Query   | Implemented          | Comments                  |
| ------- | -------------------- | ------------------------- |
| 1       | :white_check_mark:   | Need to add `tag class`   |
| 2       | :white_check_mark:   | Can't capture opt edges   |
| 3       | :white_check_mark:   | Can't capture neg edge    |
| 4       | :white_check_mark:   |                           |
| 5       | :white_check_mark:   |                           |
| 6       | :white_check_mark:   | Can't capture neg edge    |

## Validation

Only queries 1, 4, and 5 can be implemented as per the benchmark specification.
- Split query 2 into a query graph for post and for comment, ignoring optional edges.
- Ignored neg edges into queries 3 and 6. 

| Query       | Expected (Neo4j)     | Isomorphisms |
| -------     | -------------------- | ------------ |
| 1           | 3                    | 3            |
| 2 (post)    | -                    | 2            |
| 2 (comment) | -                    | 6            |
| 3           | -                    | 1            |
| 4           | 3                    | 3            |
| 5           | 6                    | 0            |
| 6           | -                    | 8            |

TODO:
- [ ] impl a dummy client
- [ ] gather results 
- [ ] switch flag for homomorphisms
