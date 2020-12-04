#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ../data

# static entities
tail -n +2 social_network/static/tag_0_0.csv | cut -d '|' -f 1 > social_network_preprocessed/tag.csv

# dynamic entities
## these start with a creation date which should be omitted

## nodes (the id is in column 2)
for entity in \
    person \
    comment \
    post \
    forum; \
do
    tail -n +2 social_network/dynamic/${entity}_0_0.csv | cut -d '|' -f 2 > social_network_preprocessed/${entity}.csv
done

## edges (the source and target ids are in columns 2 and 3)
for entity in \
    person_knows_person \
    person_likes_comment \
    person_likes_post \
    person_hasInterest_tag \
    forum_hasMember_person \
    forum_hasTag_tag \
    comment_hasTag_tag \
    post_hasTag_tag; \
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
