#!/bin/bash

# script to preprocess CSV files produced by the LDBC SNB Datagen (CsvCompositeProjectedFK serializers).

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

# replace headers
while read line; do
  IFS=' ' read -r -a array <<< $line
  FILENAME=${array[0]}
  HEADER=${array[1]}

  # replace header
  # Note that there's no point using sed to save space as it creates a temporary file as well.
  # The headers are Neo4j-compatible but they also work with relational database
  # (as most relational databases load the values based on their position and do not use the header).
  echo ${HEADER} | cat - <(tail -n +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${FILENAME}) > tmpfile.csv && mv tmpfile.csv ${IMPORT_DATA_DIR_PROJECTED_FK}/${FILENAME}
done < scripts/headers.txt
