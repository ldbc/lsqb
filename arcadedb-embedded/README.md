# ArcadeDB (embedded)

[ArcadeDB](https://arcadedb.com/) used as a library inside a JVM process, the in-process counterpart of [`../arcadedb`](../arcadedb) (which runs the server in Docker). Needs a JDK 21 or newer (`ARCADEDB_JAVA_HOME` selects one); the engine jars come from the release package on Maven Central, downloaded once by `pre-load.sh`.

* `pre-load.sh`: downloads the ArcadeDB release package and compiles `LsqbArcadeDB.java`.
* `load.sh`: creates the database (an existing one is replaced), the schema (`Post` and `Comment` extend `Message`) and loads all vertex and edge types of the merged-FK data set.
* `post-load.sh`: defines the Graph Analytical View (CSR) over all vertex and edge types.
* `run.sh [N]`: runs `cypher/q1.cypher` ... `q9.cypher`. Without an argument every query is run once (cold, like the other implementations); with `N > 0` it runs one warm-up call and writes the median of `N` timed runs (variant `embedded, warm`).

```bash
cd arcadedb-embedded
export SF=0.3
./init-and-load.sh && ./run.sh && ./stop.sh
```

The JVM heap defaults to 4 GB (`ARCADEDB_HEAP`); `ARCADEDB_JVM_FLAGS` adds JVM flags, e.g. `-XX:+UseCompactObjectHeaders` on JDK 25.

`ARCADEDB_LIB` points to a directory with the ArcadeDB jars (default: the downloaded release), e.g. a local build. `ARCADEDB_NO_GAV=1` skips the Graph Analytical View (`post-load.sh` then does nothing and the variant is reported as `embedded, no GAV`).
