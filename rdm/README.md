# RapidMatch

## Getting started

Grab [RapidMatch](https://vldb.org/pvldb/vol14/p176-sun.pdf) and build it:

```bash
./get.sh
```

## Converting data

Run the conversion script. :warning: This script first loads the data in DuckDB under in the repository's `ddb/scratch` directory.

```bash
export SF=example && ./convert.sh
```

Note that converting SF100 on a server with an NVMe SSD disk takes about ~1 hour.

The label mapping is the following:

```
Person: 0
City: 1
Country: 2
Continent: 3
Forum: 4
Post: 5
Comment: 6
Tag: 7
TagClass: 8
```

Some node  edges such as Forum-hasModerator-Person are omitted from the converted graph.

## Running the queries

When running, set [an excessive time limit](https://github.com/RapidsAtHKUST/RapidMatch/issues/1) to avoid returning too few results.

```bash
export SF=example && ./run.sh
```

### Queries

| Query   | Implemented          | Comments                             |
| ------- | -------------------- | ------------------------------------ |
| 1       | :white_check_mark:   | homomorphic/isomorphic - needs hasMember edges |
| 2       | :white_check_mark:   | homomorphic/isomorphic               |
| 3       | :white_check_mark:   | homomorphic                          |
| 4       |                      | Can't capture different edge labels  |
| 5       | :white_check_mark:   | isomorphic - needs separate C/P queries, undirected replyOf edge needs special handling |
| 6       | :white_check_mark:   | isomorphic                           |
| 7       |                      | Can't capture opt edges              |
| 8       |                      | Can't capture neg edge               |
| 9       |                      | Can't capture neg edge               |


```bash
export SF
for SF in example 0.1 0.3 1 3 10 30 100; do
  echo SF${SF}
  ./run.sh
done
```

## Validation

TODO: revise

Only queries 1, 4, and 5 can be implemented as per the benchmark specification.
- Split query 2 into a query graph for post and for comment, ignoring optional edges.
- Ignored neg edges into queries 3 and 6. 

| Query       | Expected (Neo4j)     | Isomorphisms | Homomorphisms |
| -------     | -------------------- | ------------ | ------------- |
| 1           | 3                    | 3            | 3             |
| 2 (post)    | -                    | 2            |               |
| 2 (comment) | -                    | 6            |               |
| 3           | -                    | 1            |               |
| 4           | 3                    | 3            | 3             |
| 5           | 6                    | 0            | 6             |
| 6           | -                    | 8            |               |
