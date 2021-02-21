# Umbra

The binaries of Umbra are available upon request from the TUM database group.

Copy the file archive under `umb/umbra-binaries/`, then run the following to uncompress the Umbra directories (`bin`, `lib`):

```bash
cd `git rev-parse --show-toplevel`
cd umb/umbra-binaries
tar xf umbra.tar.xz && mv umbra/* . && rm -rf umbra/ && rm umbra.tar.xz
```

## Running on Docker

```bash
./build.sh
./pre-load.sh && ./load.sh && ./Post-load.sh && ./run.sh
```
