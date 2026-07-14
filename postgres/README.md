# PostgreSQL implementation

## Profiling

```bash
docker exec lsqb-pos psql -U postgres postgres -c "explain select count(*) from person;"
```

## PGQ
PGQ support is available beginning with version 19
### Example of usage
```shell
(export SF=0.1 VARIANT=pgq POSTGRES_VERSION=19beta1 POSTGRES_SCHEMA_DIR=postgres/pgq && postgres/init-and-load.sh && postgres/run.sh && postgres/stop.sh)
```