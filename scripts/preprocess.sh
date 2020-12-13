#!/bin/bash

# script to preprocess CSV files produced by the LDBC SNB Datagen (CsvBasic or CsvComposite serializers).
# the expected output files are the following:
#
# nodes:
# - forum.csv
# - message.csv
# - person.csv
# - tag.csv
#
# edges:
# - forum_hasMember_person.csv
# - forum_hasTag_tag.csv
# - message_hasTag_tag.csv
# - person_hasInterest_tag.csv
# - person_knows_person.csv
# - person_likes_message.csv

RAW_DATA_DIR=${1:-'data/social_network'}

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

OUTPUT_DATA_DIR=`pwd`/data/social_network_preprocessed

# static entities
tail -n +2 ${RAW_DATA_DIR}/static/tag_0_0.csv | cut -d '|' -f 1 > ${OUTPUT_DATA_DIR}/tag.csv

# dynamic entities
## these start with a creation date which should be omitted

## nodes (the id is in column 2)
echo "nodes"
for entity in \
    comment \
    forum \
    person \
    post \
    ; \
do
    pv ${RAW_DATA_DIR}/dynamic/${entity}_0_0.csv | tail -n +2 | cut -d '|' -f 2 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

## edges (the source and target ids are in columns 2 and 3)
echo "edges"
for entity in \
    comment_hasTag_tag \
    forum_hasMember_person \
    forum_hasTag_tag \
    person_hasInterest_tag \
    person_knows_person \
    person_likes_comment \
    person_likes_post \
    post_hasTag_tag \
    ; \
do
    pv ${RAW_DATA_DIR}/dynamic/${entity}_0_0.csv | tail -n +2 | cut -d '|' -f 2,3 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

## merge posts and comments to message
echo "merging messages"
pv ${OUTPUT_DATA_DIR}/{comment,post}.csv > ${OUTPUT_DATA_DIR}/message.csv
pv ${OUTPUT_DATA_DIR}/person_likes_{comment,post}.csv > ${OUTPUT_DATA_DIR}/person_likes_message.csv
pv ${OUTPUT_DATA_DIR}/{comment,post}_hasTag_tag.csv > ${OUTPUT_DATA_DIR}/message_hasTag_tag.csv

## cleanup
rm ${OUTPUT_DATA_DIR}/{comment,post}.csv
rm ${OUTPUT_DATA_DIR}/person_likes_{comment,post}.csv
rm ${OUTPUT_DATA_DIR}/{comment,post}_hasTag_tag.csv

# add headers
echo "add headers"
while read line; do
  IFS=' ' read -r -a array <<< $line
  FILENAME=${array[0]}
  HEADER=${array[1]}

  # replace header (no point using sed to save space as it creates a temporary file as well)
  echo ${HEADER} | pv - ${OUTPUT_DATA_DIR}/${FILENAME} > tmpfile.csv && mv tmpfile.csv ${OUTPUT_DATA_DIR}/${FILENAME}
done < scripts/headers.txt
