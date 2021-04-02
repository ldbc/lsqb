# Umbra

The binaries of Umbra are available upon request from the TUM database group.

## Getting started

1. Decompress the Umbra `tar.gz` package, and copy the resulting `umbra.tar.xz` file archive under `umb/umbra-binaries/`, then run the following to uncompress the Umbra directories (`bin`, `lib`):

    ```bash
    cd `git rev-parse --show-toplevel`
    cd umb/umbra-binaries
    tar xf umbra.tar.xz && mv umbra/* . && rm -rf umbra/ && rm umbra.tar.xz
    ```

2. Build the Docker image

    ```bash
    cd `git rev-parse --show-toplevel`
    cd umb
    ./build.sh
    ```

## Using the SQL shell

In the `umb` directory, run:

```bash
echo "SELECT 42 AS x" > scratch/test.sql
docker exec tsmb-umb /umbra/bin/sql /scratch/ldbc.db /scratch/test.sql
```

To print the query plans for all queries, run:

```bash
./explain.sh
```

## Running on a single-thread

There are multiple options to run Umbra on a single-thread:

* Using an environment variable:

    ```bash
    PARALLEL=1 bin/sql
    ```

* Using Docker: add the `--cpuset-cpus=0` argument to the `docker run` instruction.
