# PostgreSQL implementation

## Profiling

```bash
docker exec lsqb-pos psql -U postgres postgres -c "explain select count(*) from person;"
```
