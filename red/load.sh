#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh
. scripts/import-vars.sh

redisgraph-bulk-loader \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Continent "data/social-network-${SF}-projected-fk/Continent.csv" \
    --nodes-with-label Country "data/social-network-${SF}-projected-fk/Country.csv" \
    --nodes-with-label City "data/social-network-${SF}-projected-fk/City.csv" \
    --nodes-with-label University "data/social-network-${SF}-projected-fk/University.csv" \
    --nodes-with-label Company "data/social-network-${SF}-projected-fk/Company.csv" \
    --nodes-with-label TagClass "data/social-network-${SF}-projected-fk/TagClass.csv" \
    --nodes-with-label Tag "data/social-network-${SF}-projected-fk/Tag.csv" \
    --nodes-with-label Forum "data/social-network-${SF}-projected-fk/Forum.csv" \
    --nodes-with-label Person "data/social-network-${SF}-projected-fk/Person.csv" \
    --nodes-with-label Comment "data/social-network-${SF}-projected-fk/Comment.csv" \
    --nodes-with-label Post "data/social-network-${SF}-projected-fk/Post.csv" \
    --relations-with-type IS_PART_OF "data/social-network-${SF}-projected-fk/Country_isPartOf_Continent.csv" \
    --relations-with-type IS_PART_OF "data/social-network-${SF}-projected-fk/City_isPartOf_Country.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-projected-fk/Company_isLocatedIn_Country.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-projected-fk/University_isLocatedIn_City.csv" \
    --relations-with-type IS_SUBCLASS_OF "data/social-network-${SF}-projected-fk/TagClass_isSubclassOf_TagClass.csv" \
    --relations-with-type HAS_TYPE "data/social-network-${SF}-projected-fk/Tag_hasType_TagClass.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-${SF}-projected-fk/Comment_hasCreator_Person.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-projected-fk/Comment_isLocatedIn_Place.csv" \
    --relations-with-type REPLY_OF "data/social-network-${SF}-projected-fk/Comment_replyOf_Comment.csv" \
    --relations-with-type REPLY_OF "data/social-network-${SF}-projected-fk/Comment_replyOf_Post.csv" \
    --relations-with-type CONTAINER_OF "data/social-network-${SF}-projected-fk/Forum_containerOf_Post.csv" \
    --relations-with-type HAS_MEMBER "data/social-network-${SF}-projected-fk/Forum_hasMember_Person.csv" \
    --relations-with-type HAS_MODERATOR "data/social-network-${SF}-projected-fk/Forum_hasModerator_Person.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-projected-fk/Forum_hasTag_Tag.csv" \
    --relations-with-type HAS_INTEREST "data/social-network-${SF}-projected-fk/Person_hasInterest_Tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-projected-fk/Person_isLocatedIn_Place.csv" \
    --relations-with-type KNOWS "data/social-network-${SF}-projected-fk/Person_knows_Person.csv" \
    --relations-with-type LIKES "data/social-network-${SF}-projected-fk/Person_likes_Comment.csv" \
    --relations-with-type LIKES "data/social-network-${SF}-projected-fk/Person_likes_Post.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-${SF}-projected-fk/Post_hasCreator_Person.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-projected-fk/Comment_hasTag_Tag.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-projected-fk/Post_hasTag_Tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-projected-fk/Post_isLocatedIn_Place.csv" \
    --relations-with-type STUDY_AT "data/social-network-${SF}-projected-fk/Person_studyAt_University.csv" \
    --relations-with-type WORK_AT "data/social-network-${SF}-projected-fk/Person_workAt_Company.csv" \
    --separator '|'

