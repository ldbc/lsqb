#!/bin/bash

# script to convert preprocessed CSV files to N3


set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

## nodes
for entity in \
    tag \
    tagclass \
    place \
    organisation \
    comment \
    forum \
    person \
    post \
    ;
do
    tail -qn +2 ${IMPORT_DATA_DIR}/${entity}.csv | sed "s#\(.*\)#<http://ldbcouncil.org/nodes/$entity/\1> <rdf:type> <http://ldbcouncil.org/types/${entity}>#" > ${IMPORT_DATA_DIR}/${entity}.nt
done

## edges
for entity in \
    organisation_isLocatedIn_place \
    place_isPartOf_place \
    tag_hasType_tagclass \
    tagclass_isSubclassOf_tagclass \
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
    ;
do
    types=(${entity//_/ })
    source=${types[0]}
    target=${types[2]}
    tail -qn +2 ${IMPORT_DATA_DIR}/${entity}.csv | sed "s#\([^|]*\)|\([^|]*\)#<http://ldbcouncil.org/nodes/${source}/\1> <http://ldbcouncil.org/${entity}> <http://ldbcouncil.org/nodes/${target}/\2>#" > ${IMPORT_DATA_DIR}/${entity}.nt
done
