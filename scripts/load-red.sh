#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

set -e

. scripts/red-vars.sh

scripts/start-red.sh || true
python clients/red-del.py

# TODO: Add labels to Comment/Post (issue #1)
redisgraph-bulk-loader \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Place "data/social_network_preprocessed/place.csv" \
    --nodes-with-label Organisation "data/social_network_preprocessed/organisation.csv" \
    --nodes-with-label TagClass "data/social_network_preprocessed/tagclass.csv" \
    --nodes-with-label Tag "data/social_network_preprocessed/tag.csv" \
    --nodes-with-label Forum "data/social_network_preprocessed/forum.csv" \
    --nodes-with-label Person "data/social_network_preprocessed/person.csv" \
    --nodes-with-label Comment "data/social_network_preprocessed/comment.csv" \
    --nodes-with-label Post "data/social_network_preprocessed/post.csv" \
    --relations-with-type IS_PART_OF "data/social_network_preprocessed/place_isPartOf_place.csv" \
    --relations-with-type IS_SUBCLASS_OF "data/social_network_preprocessed/tagclass_isSubclassOf_tagclass.csv" \
    --relations-with-type IS_LOCATED_IN "data/social_network_preprocessed/organisation_isLocatedIn_place.csv" \
    --relations-with-type HAS_TYPE "data/social_network_preprocessed/tag_hasType_tagclass.csv" \
    --relations-with-type HAS_CREATOR "data/social_network_preprocessed/comment_hasCreator_person.csv" \
    --relations-with-type IS_LOCATED_IN "data/social_network_preprocessed/comment_isLocatedIn_place.csv" \
    --relations-with-type REPLY_OF "data/social_network_preprocessed/comment_replyOf_comment.csv" \
    --relations-with-type REPLY_OF "data/social_network_preprocessed/comment_replyOf_post.csv" \
    --relations-with-type CONTAINER_OF "data/social_network_preprocessed/forum_containerOf_post.csv" \
    --relations-with-type HAS_MEMBER "data/social_network_preprocessed/forum_hasMember_person.csv" \
    --relations-with-type HAS_MODERATOR "data/social_network_preprocessed/forum_hasModerator_person.csv" \
    --relations-with-type HAS_TAG "data/social_network_preprocessed/forum_hasTag_tag.csv" \
    --relations-with-type HAS_INTEREST "data/social_network_preprocessed/person_hasInterest_tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social_network_preprocessed/person_isLocatedIn_place.csv" \
    --relations-with-type KNOWS "data/social_network_preprocessed/person_knows_person.csv" \
    --relations-with-type LIKES "data/social_network_preprocessed/person_likes_comment.csv" \
    --relations-with-type LIKES "data/social_network_preprocessed/person_likes_post.csv" \
    --relations-with-type HAS_CREATOR "data/social_network_preprocessed/post_hasCreator_person.csv" \
    --relations-with-type HAS_TAG "data/social_network_preprocessed/comment_hasTag_tag.csv" \
    --relations-with-type HAS_TAG "data/social_network_preprocessed/post_hasTag_tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social_network_preprocessed/post_isLocatedIn_place.csv" \
    --relations-with-type STUDY_AT "data/social_network_preprocessed/person_studyAt_organisation.csv" \
    --relations-with-type WORK_AT "data/social_network_preprocessed/person_workAt_organisation.csv" \
    --separator '|'
