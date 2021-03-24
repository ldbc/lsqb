#!/bin/bash

# script to convert preprocessed CSV files to N-Triples

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

mkdir -p ${IMPORT_DATA_DIR_NTRIPLES}

# initialize output file
echo > ${TSMB_NT_FILE}

## nodes
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
    tail -qn +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${entity}.csv | sed "s@\(.*\)@<http://ldbcouncil.org/nodes/$entity/\1> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://ldbcouncil.org/types/${entity}> .@" >> ${TSMB_NT_FILE}
done

cp ${IMPORT_DATA_DIR_PROJECTED_FK}/Person_isLocatedIn_Place.csv  ${IMPORT_DATA_DIR_PROJECTED_FK}/Person_isLocatedIn_City.csv
cp ${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_isLocatedIn_Place.csv ${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_isLocatedIn_Country.csv
cp ${IMPORT_DATA_DIR_PROJECTED_FK}/Post_isLocatedIn_Place.csv    ${IMPORT_DATA_DIR_PROJECTED_FK}/Post_isLocatedIn_Country.csv

## edges
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
    types=(${entity//_/ })
    source=${types[0]}
    edge=${types[1]}
    target=${types[2]}

    predicate_source=${source}
    predicate_source=${predicate_source/Comment/Message}
    predicate_source=${predicate_source/Post/Message}

    predicate_target=${target}
    predicate_target=${predicate_target/Comment/Message}
    predicate_target=${predicate_target/Post/Message}

    tail -qn +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${entity}.csv | sed "s#\([^|]*\)|\([^|]*\)#<http://ldbcouncil.org/nodes/${source}/\1> <http://ldbcouncil.org/${predicate_source}_${edge}_${predicate_target}> <http://ldbcouncil.org/nodes/${target}/\2> .#" >> ${TSMB_NT_FILE}
done

rm ${IMPORT_DATA_DIR_PROJECTED_FK}/Person_isLocatedIn_City.csv
rm ${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_isLocatedIn_Country.csv
rm ${IMPORT_DATA_DIR_PROJECTED_FK}/Post_isLocatedIn_Country.csv
