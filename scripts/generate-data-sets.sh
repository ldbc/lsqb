#!/bin/bash

TSMB_DATA_DIR=~/git/snb/tsmb/data/
CONVERTER_REPOSITORY_DIR=~/git/snb/ldbc-example-graph

for SF in 0.1 0.3 1 3 10; do
    echo SF: ${SF}
    time ./tools/run.py ./target/ldbc_snb_datagen-0.4.0-SNAPSHOT.jar --parallelism 4 --memory 16G -- --format csv --mode raw --scale-factor ${SF} --output-dir out/sf${SF}-raw
done

cd ${CONVERTER_REPOSITORY_DIR}

for SF in 0.1 0.3 1 3 10; do
    echo SF: ${SF}
    export DATAGEN_DATA_DIR=/home/szarnyasg/git/snb/ldbc_snb_datagen/out/sf${SF}-raw/csv/raw/composite_merge_foreign
    ./spark-concat.sh ${DATAGEN_DATA_DIR}
    ./proc.sh ${DATAGEN_DATA_DIR} --no-header

    cat snb-export-only-ids-projected-fk.sql | ./duckdb ldbc.duckdb
    cat snb-export-only-ids-merged-fk.sql    | ./duckdb ldbc.duckdb

    cp -r data/csv-only-ids-projected-fk/ ${TSMB_DATA_DIR}/social-network-sf${SF}-projected-fk
    cp -r data/csv-only-ids-merged-fk/    ${TSMB_DATA_DIR}/social-network-sf${SF}-merged-fk
done

# the SF10 generator and the conversion scripts ran on my laptop with 24 GB RAM with some browser tabs/apps open (during conversion, it swapped a bit)
