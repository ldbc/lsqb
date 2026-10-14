# ArcadeDB

[ArcadeDB](https://arcadedb.com/) runs in Docker (`arcadedata/arcadedb`, default version in `vars.sh`, override with `ARCADEDB_VERSION`) and is accessed over its HTTP API with the standard library only (no extra Python packages).

* `pre-load.sh`: starts a fresh server container, the database directory is `scratch/databases`.
* `load.sh`: creates the schema (`Post` and `Comment` extend `Message`, so the `:Message` label matches both) and loads the merged-FK CSVs through the streaming `/api/v1/batch` endpoint.
* `post-load.sh`: builds a Graph Analytical View (CSR) over all vertex and edge types; the queries run without it, but it accelerates traversals.
* `run.sh`: runs `cypher/q1.cypher` ... `q9.cypher` with openCypher.
* `stop.sh`: stops (and removes) the container.

All vertex and edge types of the merged-FK data set are loaded, not only the ones the nine queries touch.

```bash
cd arcadedb
export SF=0.3
./init-and-load.sh && ./run.sh && ./stop.sh
```

The server listens on port 22480 (`ARCADEDB_HTTP_PORT`), not the default 2480, so that it does not clash with an ArcadeDB already running on the machine.

The server heap defaults to 4 GB (`ARCADEDB_HEAP`). Scale factors up to 0.3 load within it; SF1 needs more because the batch loader finishes the whole request at once (`ARCADEDB_HEAP=8G ./init-and-load.sh`). Edges refer to vertices by position in the payload (`refMode=ordinal`) to keep the loader's memory small, and the 100 MB request body cap is lifted for the loader.
