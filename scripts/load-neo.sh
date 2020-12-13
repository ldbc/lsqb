#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/neo-vars.sh

mkdir -p ${NEO4J_HOME}/{logs,import,plugins}

# start with a fresh data dir (required by the CSV importer)
mkdir -p ${NEO4J_DATA_DIR}
rm -rf ${NEO4J_DATA_DIR}/*

docker run --rm \
    --user="$(id -u):$(id -g)" \
    --publish=17474:7474 \
    --publish=17687:7687 \
    --volume=${NEO4J_DATA_DIR}:/data \
    --volume=${IMPORT_DIR}:/import \
    neo4j:${NEO4J_VERSION} \
    neo4j-admin import \
    --nodes=Forum=/import/forum.csv \
    --nodes=Message=/import/message.csv \
    --nodes=Person=/import/person.csv \
    --nodes=Tag=/import/tag.csv \
    --relationships=FORUM_HAS_TAG=/import/forum_hasTag_tag.csv \
    --relationships=HAS_INTEREST=/import/person_hasInterest_tag.csv \
    --relationships=HAS_MEMBER=/import/forum_hasMember_person.csv \
    --relationships=KNOWS=/import/person_knows_person.csv \
    --relationships=LIKES=/import/person_likes_message.csv \
    --relationships=MESSAGE_HAS_TAG=/import/message_hasTag_tag.csv \
    --delimiter '|'
