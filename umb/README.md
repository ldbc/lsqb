# Umbra

The binaries of Umbra are available upon request from the TUM database group.

## Getting started

Load the Umbra image:

```bash
export UMBRA_URL_PREFIX=...
./docker-load.sh
```

## Running on a single-thread

There are multiple options to run Umbra on a single-thread:

* Using an environment variable:

    ```bash
    PARALLEL=1 bin/sql
    ```

* Using Docker: add the `--cpuset-cpus=0` argument to the `docker run` instruction.
