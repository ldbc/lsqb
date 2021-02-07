# Dgraph

```bash
curl https://get.dgraph.io -sSf | bash
dgraph zero
```

In a separate terminal, bulk load the data with

```bash
dgraph bulk -f ldbc.rdf -s ldbc.schema --map_shards=4 --reduce_shards=2 --http localhost:8000 --zero=localhost:5080
```
