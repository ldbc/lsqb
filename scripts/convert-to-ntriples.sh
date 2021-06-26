#!/bin/bash

# script to convert preprocessed CSV files to N-Triples

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

mkdir -p ${IMPORT_DATA_DIR_NTRIPLES}

# initialize output file
echo > ${LSQB_NT_FILE}

## nodes
echo "Converting nodes"
for entity in \
    Tag \
    TagClass \
    City \
    Country \
    Continent \
    University \
    Company \
    Comment \
    Forum \
    Person \
    Post \
    ;
do
    echo "- ${entity}"
    tail -qn +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${entity}.csv | sed "s#\(.*\)#<http://ldbcouncil.org/nodes/$entity/\1> a <http://ldbcouncil.org/types/${entity}> .#" >> ${LSQB_NT_FILE}
done

## edges
echo "Converting edges"
for entity in \
    University_isLocatedIn_City \
    Company_isLocatedIn_Country \
    Country_isPartOf_Continent \
    City_isPartOf_Country \
    Tag_hasType_TagClass \
    TagClass_isSubclassOf_TagClass \
    Comment_hasCreator_Person \
    Comment_hasTag_Tag \
    Comment_isLocatedIn_Country \
    Comment_replyOf_Comment \
    Comment_replyOf_Post \
    Forum_containerOf_Post \
    Forum_hasMember_Person \
    Forum_hasModerator_Person \
    Forum_hasTag_Tag \
    Person_hasInterest_Tag \
    Person_isLocatedIn_City \
    Person_knows_Person \
    Person_likes_Comment \
    Person_likes_Post \
    Person_studyAt_University \
    Person_workAt_Company \
    Post_hasCreator_Person \
    Post_hasTag_Tag \
    Post_isLocatedIn_Country \
    ;
do
    echo "- ${entity}"
    types=(${entity//_/ })
    source=${types[0]}
    target=${types[2]}
    tail -qn +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${entity}.csv | sed "s#\([^|]*\)|\([^|]*\)#<http://ldbcouncil.org/nodes/${source}/\1> <http://ldbcouncil.org/${entity}> <http://ldbcouncil.org/nodes/${target}/\2> .#" >> ${LSQB_NT_FILE}
done
