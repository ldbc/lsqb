# HyPer

## Building the image

Grab the binaries from `${SECRET_HYPER_BINARIES_URL}` and build the container:

```bash
wget ${SECRET_HYPER_BINARIES_URL}
tar xf hyper.tar.xz
mv hyper hyper-binaries
./build.sh
```

This will place the HyPer binaries in the `hyper-binaries/hyper/` directory.

## Use the SQL prompt to test

```bash
echo "SELECT 42 AS x" | docker exec -i lsqb-hyp psql -U lsqbuser -p 7484 -h localhost lsqb
```
