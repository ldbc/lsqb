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
    Organisation_isLocatedIn_Place \
    Place_isPartOf_Place \
    Tag_hasType_TagClass \
    TagClass_isSubclassOf_TagClass \
    Comment_hasCreator_Person \
    Comment_hasTag_Tag \
    Comment_isLocatedIn_Place \
    Comment_replyOf_Comment \
    Comment_replyOf_Post \
    Forum_containerOf_Post \
    Forum_hasMember_Person \
    Forum_hasModerator_Person \
    Forum_hasTag_Tag \
    Person_hasInterest_Tag \
    Person_isLocatedIn_Place \
    Person_knows_Person \
    Person_likes_Comment \
    Person_likes_Post \
    Person_studyAt_Organisation \
    Person_workAt_Organisation \
    Post_hasCreator_Person \
    Post_hasTag_Tag \
    Post_isLocatedIn_Place \
    ;
do
    types=(${entity//_/ })
    source=${types[0]}
    target=${types[2]}
    tail -qn +2 ${IMPORT_DATA_DIR}/${entity}.csv | sed "s#\([^|]*\)|\([^|]*\)#<http://ldbcouncil.org/nodes/${source}/\1> <http://ldbcouncil.org/${entity}> <http://ldbcouncil.org/nodes/${target}/\2>#" > ${IMPORT_DATA_DIR}/${entity}.nt
done
