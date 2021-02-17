## Umbra/Docker execute scripts with `bin/sql`

Queries in the Umbra/Docker setup can be run without the server as follows:

```bash
for i in $(seq 1 6); do
  echo ============ Q${i} ============
  cp ../sql/q${i}.sql scratch/
  docker exec --interactive ${UMBRA_CONTAINER_NAME} /umbra/bin/sql /scratch/ldbc.db /scratch/q${i}.sql
done
```
