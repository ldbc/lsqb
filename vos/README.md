
# OpenLink Virtuoso

## Configuration:

Set the `virtuoso.ini` configuration file to match your resources:

For benchmarking, use:

```bash
cp virtuoso-large.ini virtuoso.ini
```

For local development, use:

```bash
cp virtuoso-small.ini virtuoso.ini
```

Then, convert the data and run the benchmark as follows:

```bash
scripts/install-dependencies.sh \
    && scripts/convert-to-ntriples.sh \
    && vos/init-and-load.sh \
    && vos/run.sh \
    && vos/stop.sh
```
