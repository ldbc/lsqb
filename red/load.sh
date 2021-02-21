#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh
. scripts/import-vars.sh

# TODO: Add labels to Comment/Post (issue #1)
redisgraph-bulk-loader \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Continent "data/social-network-${SF}-preprocessed/continent.csv" \
    --nodes-with-label Country "data/social-network-${SF}-preprocessed/country.csv" \
    --nodes-with-label City "data/social-network-${SF}-preprocessed/city.csv" \
    --nodes-with-label University "data/social-network-${SF}-preprocessed/university.csv" \
    --nodes-with-label Company "data/social-network-${SF}-preprocessed/company.csv" \
    --nodes-with-label TagClass "data/social-network-${SF}-preprocessed/tagclass.csv" \
    --nodes-with-label Tag "data/social-network-${SF}-preprocessed/tag.csv" \
    --nodes-with-label Forum "data/social-network-${SF}-preprocessed/forum.csv" \
    --nodes-with-label Person "data/social-network-${SF}-preprocessed/person.csv" \
    --nodes-with-label Comment "data/social-network-${SF}-preprocessed/comment.csv" \
    --nodes-with-label Post "data/social-network-${SF}-preprocessed/post.csv" \
    --relations-with-type IS_SUBCLASS_OF "data/social-network-${SF}-preprocessed/tagclass_isSubclassOf_tagclass.csv" \
    --relations-with-type HAS_TYPE "data/social-network-${SF}-preprocessed/tag_hasType_tagclass.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-${SF}-preprocessed/comment_hasCreator_person.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/comment_isLocatedIn_place.csv" \
    --relations-with-type REPLY_OF "data/social-network-${SF}-preprocessed/comment_replyOf_comment.csv" \
    --relations-with-type REPLY_OF "data/social-network-${SF}-preprocessed/comment_replyOf_post.csv" \
    --relations-with-type CONTAINER_OF "data/social-network-${SF}-preprocessed/forum_containerOf_post.csv" \
    --relations-with-type HAS_MEMBER "data/social-network-${SF}-preprocessed/forum_hasMember_person.csv" \
    --relations-with-type HAS_MODERATOR "data/social-network-${SF}-preprocessed/forum_hasModerator_person.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-preprocessed/forum_hasTag_tag.csv" \
    --relations-with-type HAS_INTEREST "data/social-network-${SF}-preprocessed/person_hasInterest_tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/person_isLocatedIn_place.csv" \
    --relations-with-type KNOWS "data/social-network-${SF}-preprocessed/person_knows_person.csv" \
    --relations-with-type LIKES "data/social-network-${SF}-preprocessed/person_likes_comment.csv" \
    --relations-with-type LIKES "data/social-network-${SF}-preprocessed/person_likes_post.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-${SF}-preprocessed/post_hasCreator_person.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-preprocessed/comment_hasTag_tag.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-preprocessed/post_hasTag_tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/post_isLocatedIn_place.csv" \
    --relations-with-type STUDY_AT "data/social-network-${SF}-preprocessed/person_studyAt_organisation.csv" \
    --relations-with-type WORK_AT "data/social-network-${SF}-preprocessed/person_workAt_organisation.csv" \
    --separator '|'

#    --relations-with-type IS_PART_OF "data/social-network-${SF}-preprocessed/place_isPartOf_place.csv" \
#    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/organisation_isLocatedIn_place.csv" \
