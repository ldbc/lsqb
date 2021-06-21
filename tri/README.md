
docker build -f trident.dockerfile -t  karmaresearch/trident:latest . 


docker run -it --rm -v ${PWD}:/data   karmaresearch/trident

build/trident load -l debug -f /data/scratch/db/  -i /data/scratch/out  --logfile /data/scratch/out.log  --enableFixedStrat 1 --fixedStrat 96
cat /data/scratch/out.log

for q in /data/tri/scratch/queries/q*
do
build/trident query -l info -i  /data/scratch/out -q $q
done


