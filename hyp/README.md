# HyPer

## Building the image

Place the HyPer binaries under `hyper-binaries/hyper` and run:

```bash
wget ${SECRET_HYPER_BINARIES_URL}
tar xf hyper.tar.xz
mv hyper hyper-binaries
./build.sh
```

## Using the SQL prompt

```bash
echo "SELECT 42 AS x" | docker exec -i lsqb-hyp psql -U lsqbuser -p 7484 -h localhost lsqb
```
