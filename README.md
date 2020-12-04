# Typed Subgraph Matching Benchmark

A benchmark for subgraph matching but with types information (edge types, mostly).

Inspired by LDBC SNB and JOB.

## Getting started

We currently load the data in a Dockerized Neo4j instance.

```bash
scripts/preprocess.sh
scripts/load-neo4j.sh
```

## Philoshopy

This is designed to be a simple benchmark. We do not provide auditing guidelines - it's the user's responsibility to ensure that the benchmark setup is meaningful.
