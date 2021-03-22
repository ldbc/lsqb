
# Jena + Worst Case Optimal Join (Leapfrog)

```bash
scripts/install-dependencies.sh \
    && scripts/convert-to-ntriples.sh \
    && woj/pre-load.sh \
    && woj/load.sh \
    && woj/post-load.sh \
    && woj/run.sh \
    && woj/stop.sh
```
