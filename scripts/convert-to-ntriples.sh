#!/bin/bash

# script to convert preprocessed CSV files to N-Triples

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

# initialize output file
echo > ${IMPORT_DATA_DIR_PROJECTED_FK}/ldbc.nt

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
    tail -qn +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${entity}.csv | sed "s#\(.*\)#<http://ldbcouncil.org/nodes/$entity/\1> a <http://ldbcouncil.org/types/${entity}> .#" >> ${IMPORT_DATA_DIR_PROJECTED_FK}/ldbc.nt
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
    target=${types[2]}
    tail -qn +2 ${IMPORT_DATA_DIR_PROJECTED_FK}/${entity}.csv | sed "s#\([^|]*\)|\([^|]*\)#<http://ldbcouncil.org/nodes/${source}/\1> <http://ldbcouncil.org/${entity}> <http://ldbcouncil.org/nodes/${target}/\2> .#" >> ${IMPORT_DATA_DIR_PROJECTED_FK}/ldbc.nt
done

rm ${IMPORT_DATA_DIR_PROJECTED_FK}/Person_isLocatedIn_City.csv
rm ${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_isLocatedIn_Country.csv
rm ${IMPORT_DATA_DIR_PROJECTED_FK}/Post_isLocatedIn_Country.csv
