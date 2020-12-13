#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..


docker run \
    --rm \
    --detach \
    --publish=6379:6379 \
    redislabs/redisgraph

redisgraph-bulk-loader \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Forum data/social_network_preprocessed/forum.csv \
    --nodes-with-label Message data/social_network_preprocessed/message.csv \
    --nodes-with-label Person data/social_network_preprocessed/person.csv \
    --nodes-with-label Tag data/social_network_preprocessed/tag.csv \
    --relations-with-type FORUM_HAS_TAG data/social_network_preprocessed/forum_hasTag_tag.csv \
    --relations-with-type HAS_INTEREST data/social_network_preprocessed/person_hasInterest_tag.csv \
    --relations-with-type HAS_MEMBER data/social_network_preprocessed/forum_hasMember_person.csv \
    --relations-with-type KNOWS data/social_network_preprocessed/person_knows_person.csv \
    --relations-with-type LIKES data/social_network_preprocessed/person_likes_message.csv \
    --relations-with-type MESSAGE_HAS_TAG data/social_network_preprocessed/message_hasTag_tag.csv \
    --separator '|'
