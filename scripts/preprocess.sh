#!/bin/bash

# script to preprocess CSV files produced by the LDBC SNB Datagen (CsvCompositeProjectedFK serializers).

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

RAW_DATA_DIR=`pwd`/data/social-network-${SF}-raw
OUTPUT_DATA_DIR=`pwd`/data/social-network-${SF}-projected-fk

# make sure the output directory exists
mkdir -p ${OUTPUT_DATA_DIR}

# static entities

## nodes (the id is in column 1)
echo "-------------------- static nodes --------------------"
for entity in \
    Tag \
    TagClass \
    University \
    Company \
    City \
    Country \
    Continent \
    ; \
do
    tail -qn +2 ${RAW_DATA_DIR}/static/${entity}.csv | cut -d '|' -f 1 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

## edges (the source and target ids are in columns 1 and 2)
echo "-------------------- static edges --------------------"
for entity in \
    Company_isLocatedIn_Country \
    University_isLocatedIn_City \
    City_isPartOf_Country \
    Country_isPartOf_Continent \
    Tag_hasType_TagClass \
    TagClass_isSubclassOf_TagClass \
    ; \
do
    tail -qn +2 ${RAW_DATA_DIR}/static/${entity}.csv | cut -d '|' -f 1,2 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

# dynamic entities
## these start with a creation date which should be omitted

## nodes (the id is in column 2)
echo "-------------------- dynamic nodes -------------------"
for entity in \
    Comment \
    Forum \
    Person \
    Post \
    ; \
do
    tail -qn +2 ${RAW_DATA_DIR}/dynamic/${entity}.csv | cut -d '|' -f 2 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

## edges (the source and target ids are in columns 2 and 3)
echo "-------------------- dynamic edges -------------------"
for entity in \
    Comment_hasCreator_Person \
    Comment_hasTag_Tag \
    Comment_isLocatedIn_Place \
    Comment_replyOf_Comment \
    Comment_replyOf_Post \
    Forum_containerOf_Post \
    Forum_hasMember_Person \
    Forum_hasModerator_Person \
    Forum_hasTag_Tag \
    Person_hasInterest_Tag \
    Person_isLocatedIn_Place \
    Person_knows_Person \
    Person_likes_Comment \
    Person_likes_Post \
    Person_studyAt_University \
    Person_workAt_Company \
    Post_hasCreator_Person \
    Post_hasTag_Tag \
    Post_isLocatedIn_Place \
    ; \
do
    tail -qn +2 ${RAW_DATA_DIR}/dynamic/${entity}.csv | cut -d '|' -f 2,3 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

# add headers
echo "--------------------- add headers --------------------"
while read line; do
  IFS=' ' read -r -a array <<< $line
  FILENAME=${array[0]}
  HEADER=${array[1]}

  # replace header
  # Note that there's no point using sed to save space as it creates a temporary file as well.
  # The headers are Neo4j-compatible but they also work with relational database
  # (as most relational databases load the values based on their position and do not use the header).
  echo ${HEADER} | cat - ${OUTPUT_DATA_DIR}/${FILENAME} > tmpfile.csv && mv tmpfile.csv ${OUTPUT_DATA_DIR}/${FILENAME}
done < scripts/headers.txt
