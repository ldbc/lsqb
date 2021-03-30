# HyPer

## Building the image

Place the HyPer binaries under `hyper-binaries/hyper` and run:

```bash
./build.sh
```

## Using the SQL prompt

```bash
echo "SELECT 42 AS x" | docker exec -i tsmb-hyp psql -U raasveld -p 7484 -h localhost tsmb
```
