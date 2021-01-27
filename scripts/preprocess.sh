#!/bin/bash

# script to preprocess CSV files produced by the LDBC SNB Datagen (CsvSingularProjectedFK or CsvSingularMergedFK serializers).

RAW_DATA_DIR=${1:-'data/social_network'}

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

OUTPUT_DATA_DIR=`pwd`/data/social_network_preprocessed

# make sure the output directory exists
mkdir -p ${OUTPUT_DATA_DIR}

# static entities

## nodes (the id is in column 1)
echo "-------------------- static nodes --------------------"
pv ${RAW_DATA_DIR}/static/tag_0_0.csv          | tail -n +2 | cut -d '|' -f 1   > ${OUTPUT_DATA_DIR}/tag.csv
pv ${RAW_DATA_DIR}/static/tagclass_0_0.csv     | tail -n +2 | cut -d '|' -f 1   > ${OUTPUT_DATA_DIR}/tagclass.csv
pv ${RAW_DATA_DIR}/static/place_0_0.csv        | tail -n +2 | cut -d '|' -f 1,4 > ${OUTPUT_DATA_DIR}/place.csv
pv ${RAW_DATA_DIR}/static/organisation_0_0.csv | tail -n +2 | cut -d '|' -f 1,2 > ${OUTPUT_DATA_DIR}/organisation.csv

## edges (the source and target ids are in columns 1 and 2)
echo "-------------------- static edges --------------------"
for entity in \
    organisation_isLocatedIn_place \
    place_isPartOf_place \
    tag_hasType_tagclass \
    tagclass_isSubclassOf_tagclass \
    ; \
do
    pv ${RAW_DATA_DIR}/static/${entity}_0_0.csv | tail -n +2 | cut -d '|' -f 1,2 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

# dynamic entities
## these start with a creation date which should be omitted

## nodes (the id is in column 2)
echo "-------------------- dynamic nodes -------------------"
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
echo "-------------------- dynamic edges -------------------"
for entity in \
    comment_hasCreator_person \
    comment_hasTag_tag \
    comment_isLocatedIn_place \
    comment_replyOf_comment \
    comment_replyOf_post \
    forum_containerOf_post \
    forum_hasMember_person \
    forum_hasModerator_person \
    forum_hasTag_tag \
    person_hasInterest_tag \
    person_isLocatedIn_place \
    person_knows_person \
    person_likes_comment \
    person_likes_post \
    person_studyAt_organisation \
    person_workAt_organisation \
    post_hasCreator_person \
    post_hasTag_tag \
    post_isLocatedIn_place \
    ; \
do
    pv ${RAW_DATA_DIR}/dynamic/${entity}_0_0.csv | tail -n +2 | cut -d '|' -f 2,3 > ${OUTPUT_DATA_DIR}/${entity}.csv
done

# ## merge posts and comments to message
# echo "merging messages"
# pv ${OUTPUT_DATA_DIR}/{comment,post}.csv > ${OUTPUT_DATA_DIR}/message.csv
# pv ${OUTPUT_DATA_DIR}/person_likes_{comment,post}.csv > ${OUTPUT_DATA_DIR}/person_likes_message.csv
# pv ${OUTPUT_DATA_DIR}/{comment,post}_hasTag_tag.csv > ${OUTPUT_DATA_DIR}/message_hasTag_tag.csv

# ## cleanup
# rm ${OUTPUT_DATA_DIR}/{comment,post}.csv
# rm ${OUTPUT_DATA_DIR}/person_likes_{comment,post}.csv
# rm ${OUTPUT_DATA_DIR}/{comment,post}_hasTag_tag.csv

# add headers
echo "--------------------- add headers --------------------"
while read line; do
  IFS=' ' read -r -a array <<< $line
  FILENAME=${array[0]}
  HEADER=${array[1]}

  # replace header (no point using sed to save space as it creates a temporary file as well)
  echo ${HEADER} | pv - ${OUTPUT_DATA_DIR}/${FILENAME} > tmpfile.csv && mv tmpfile.csv ${OUTPUT_DATA_DIR}/${FILENAME}
done < scripts/headers.txt
