
# OpenLink Virtuoso

```bash
scripts/install-dependencies.sh \
    && scripts/convert-to-ntriples.sh \
    && vos/pre-load.sh \
    && vos/load.sh \
    && vos/post-load.sh \
    && vos/run.sh \
    && vos/stop.sh
```
