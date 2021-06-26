# Trident implementation

Build Docker image:
```
docker build -f trident.dockerfile -t  karmaresearch/trident:latest . 
```

Start the image by issuing the following command in the repository root:
```
docker run -it --rm -v ${PWD}:/data karmaresearch/trident
```

Run the following commands:
```
build/trident load -l debug -f /data/tri/scratch/db/  -i /data/tri/scratch/out  --logfile /data/tri/scratch/out.log  --enableFixedStrat 1 --fixedStrat 96
cat /data/tri/scratch/out.log

for q in /data/tri/sparql/q*.sparql; do
    build/trident query -l info -i  /data/tri/scratch/out -q $q
done
```