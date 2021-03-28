# PostgreSQL implementation

## Profiling

```bash
docker exec tsmb-pos psql -U postgres postgres -c "explain select count(*) from person;"
```
