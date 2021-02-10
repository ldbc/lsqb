#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh

# TODO: Add labels to Comment/Post (issue #1)
redisgraph-bulk-loader \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Place "data/social-network-preprocessed/place.csv" \
    --nodes-with-label Organisation "data/social-network-preprocessed/organisation.csv" \
    --nodes-with-label TagClass "data/social-network-preprocessed/tagclass.csv" \
    --nodes-with-label Tag "data/social-network-preprocessed/tag.csv" \
    --nodes-with-label Forum "data/social-network-preprocessed/forum.csv" \
    --nodes-with-label Person "data/social-network-preprocessed/person.csv" \
    --nodes-with-label Comment "data/social-network-preprocessed/comment.csv" \
    --nodes-with-label Post "data/social-network-preprocessed/post.csv" \
    --relations-with-type IS_PART_OF "data/social-network-preprocessed/place_isPartOf_place.csv" \
    --relations-with-type IS_SUBCLASS_OF "data/social-network-preprocessed/tagclass_isSubclassOf_tagclass.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-preprocessed/organisation_isLocatedIn_place.csv" \
    --relations-with-type HAS_TYPE "data/social-network-preprocessed/tag_hasType_tagclass.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-preprocessed/comment_hasCreator_person.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-preprocessed/comment_isLocatedIn_place.csv" \
    --relations-with-type REPLY_OF "data/social-network-preprocessed/comment_replyOf_comment.csv" \
    --relations-with-type REPLY_OF "data/social-network-preprocessed/comment_replyOf_post.csv" \
    --relations-with-type CONTAINER_OF "data/social-network-preprocessed/forum_containerOf_post.csv" \
    --relations-with-type HAS_MEMBER "data/social-network-preprocessed/forum_hasMember_person.csv" \
    --relations-with-type HAS_MODERATOR "data/social-network-preprocessed/forum_hasModerator_person.csv" \
    --relations-with-type HAS_TAG "data/social-network-preprocessed/forum_hasTag_tag.csv" \
    --relations-with-type HAS_INTEREST "data/social-network-preprocessed/person_hasInterest_tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-preprocessed/person_isLocatedIn_place.csv" \
    --relations-with-type KNOWS "data/social-network-preprocessed/person_knows_person.csv" \
    --relations-with-type LIKES "data/social-network-preprocessed/person_likes_comment.csv" \
    --relations-with-type LIKES "data/social-network-preprocessed/person_likes_post.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-preprocessed/post_hasCreator_person.csv" \
    --relations-with-type HAS_TAG "data/social-network-preprocessed/comment_hasTag_tag.csv" \
    --relations-with-type HAS_TAG "data/social-network-preprocessed/post_hasTag_tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-preprocessed/post_isLocatedIn_place.csv" \
    --relations-with-type STUDY_AT "data/social-network-preprocessed/person_studyAt_organisation.csv" \
    --relations-with-type WORK_AT "data/social-network-preprocessed/person_workAt_organisation.csv" \
    --separator '|'
