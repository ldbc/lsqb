#!/bin/bash

# edit the script before running it

# memory requirements:
# the SF10 generator and the conversion scripts ran on my laptop with 24 GB RAM with some browser tabs/apps open (during conversion, it swapped a bit)

set -eu
set -o pipefail

DATAGEN_DIR=~/git/snb/ldbc_snb_datagen/
LSQB_DIR=~/git/snb/lsqb/
CONVERTER_REPOSITORY_DIR=~/git/snb/ldbc_snb_data_converter
SFS="0.1 0.3 1 3 10"

cd ${DATAGEN_DIR}

for SF in ${SFS}; do
    echo Generating SF ${SF}
    time ./tools/run.py ./target/ldbc_snb_datagen-0.4.0-SNAPSHOT.jar --parallelism 4 --memory 16G -- --format csv --mode raw --scale-factor ${SF} --output-dir out/sf${SF}-raw
done

cd ${CONVERTER_REPOSITORY_DIR}

for SF in ${SFS}; do
    echo Converting SF ${SF}
    export DATAGEN_DATA_DIR=${DATAGEN_DIR}/out/sf${SF}-raw/csv/raw/composite-merged-fk
    ./spark-concat.sh ${DATAGEN_DATA_DIR}
    ./proc.sh ${DATAGEN_DATA_DIR} --no-header

    echo exporting data
    cat snb-export-only-ids-projected-fk.sql | ./duckdb ldbc.duckdb
    cat snb-export-only-ids-merged-fk.sql    | ./duckdb ldbc.duckdb

    echo copying data
    cp -r data/csv-only-ids-projected-fk/ ${LSQB_DIR}/data/social-network-sf${SF}-projected-fk
    cp -r data/csv-only-ids-merged-fk/    ${LSQB_DIR}/data/social-network-sf${SF}-merged-fk
done

cd ${LSQB_DIR}

echo `pwd`

for SF in ${SFS}; do
    echo Preprocessing SF ${SF}
    scripts/preprocess.sh
done
