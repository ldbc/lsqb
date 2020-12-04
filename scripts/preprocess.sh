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

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ../data

# static entities
tail -n +2 social_network/static/tag_0_0.csv | cut -d '|' -f 1 > social_network_preprocessed/tag.csv

# dynamic entities
## these start with a creation date which should be omitted

## nodes (the id is in column 2)
for entity in \
    comment \
    forum \
    person \
    post \
    ; \
do
    tail -n +2 social_network/dynamic/${entity}_0_0.csv | cut -d '|' -f 2 > social_network_preprocessed/${entity}.csv
done

## edges (the source and target ids are in columns 2 and 3)
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
    tail -n +2 social_network/dynamic/${entity}_0_0.csv | cut -d '|' -f 2,3 > social_network_preprocessed/${entity}.csv
done

## merge posts and comments to message
cat social_network_preprocessed/{comment,post}.csv > social_network_preprocessed/message.csv
cat social_network_preprocessed/person_likes_{comment,post}.csv > social_network_preprocessed/person_likes_message.csv
cat social_network_preprocessed/{comment,post}_hasTag_tag.csv > social_network_preprocessed/message_hasTag_tag.csv

## cleanup
rm social_network_preprocessed/{comment,post}.csv
rm social_network_preprocessed/person_likes_{comment,post}.csv
rm social_network_preprocessed/{comment,post}_hasTag_tag.csv

# add headers
while read line; do
  IFS=' ' read -r -a array <<< $line
  FILENAME=${array[0]}
  HEADER=${array[1]}

  # replace header (no point using sed to save space as it creates a temporary file as well)
  echo ${HEADER} | cat - social_network_preprocessed/${FILENAME} > tmpfile.csv && mv tmpfile.csv social_network_preprocessed/${FILENAME}
done < ../scripts/headers.txt
