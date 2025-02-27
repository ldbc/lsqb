## Data generation

You can generate your own data sets for LSQB. Note that these may slightly differ in size for different versions of the data generator – for publications, it's recommended to use the pre-generated data sets linked above.

1. Run the [LDBC Spark Datagen](https://github.com/ldbc/ldbc_snb_datagen/) using CSV outputs and raw mode (see its README for instructions).

1. Use the scripts in the [converter](https://github.com/ldbc/ldbc_snb_data_converter) repository:

   ```bash
   cd out/csv/raw/composite_merge_foreign/
   export DATAGEN_DATA_DIR=`pwd`
   ```

1. Go to the [data converter repository](https://github.com/ldbc/ldbc_snb_data_converter):

   ```bash
   ./spark-concat.sh ${DATAGEN_DATA_DIR}
   ./load.sh ${DATAGEN_DATA_DIR} --no-header
   ./transform.sh
   cat export/snb-export-only-ids-projected-fk.sql | ./duckdb ldbc.duckdb
   cat export/snb-export-only-ids-merged-fk.sql    | ./duckdb ldbc.duckdb
   ```

1. Copy the generated files:

   ```bash
   export SF=1
   cp -r data/csv-only-ids-projected-fk/ ${LSQB_REPOSITORY_DIRECTORY}/data/social-network-sf${SF}-projected-fk
   cp -r data/csv-only-ids-merged-fk/    ${LSQB_REPOSITORY_DIRECTORY}/data/social-network-sf${SF}-merged-fk
   ```
