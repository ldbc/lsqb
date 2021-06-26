#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

. scripts/import-vars.sh

export RAPIDMATCH_HOMOMORPHIC_DIR=`pwd`/rdm/scratch/RapidMatch-homomorphic/
export RAPIDMATCH_ISOMORPHIC_DIR=`pwd`/rdm/scratch/RapidMatch-isomorphic/
export DATA_GRAPH=`pwd`/data/rdm/ldbc-${SF}.graph
export RAPIDMATCH_PARAMS="-order nd -time_limit 36000 -preprocess true -num MAX"

export QUERY=1; ${RAPIDMATCH_ISOMORPHIC_DIR}/build/matching/RapidMatch.out  ${RAPIDMATCH_PARAMS} -d ${DATA_GRAPH} -q rdm/query_graphs/q${QUERY}.graph | python3 rdm/process.py
export QUERY=2; ${RAPIDMATCH_ISOMORPHIC_DIR}/build/matching/RapidMatch.out  ${RAPIDMATCH_PARAMS} -d ${DATA_GRAPH} -q rdm/query_graphs/q${QUERY}.graph | python3 rdm/process.py
export QUERY=3; ${RAPIDMATCH_HOMOMORPHIC_DIR}/build/matching/RapidMatch.out ${RAPIDMATCH_PARAMS} -d ${DATA_GRAPH} -q rdm/query_graphs/q${QUERY}.graph | python3 rdm/process.py
export QUERY=5p; ${RAPIDMATCH_ISOMORPHIC_DIR}/build/matching/RapidMatch.out ${RAPIDMATCH_PARAMS} -d ${DATA_GRAPH} -q rdm/query_graphs/q${QUERY}.graph | python3 rdm/process.py
export QUERY=5c; ${RAPIDMATCH_ISOMORPHIC_DIR}/build/matching/RapidMatch.out ${RAPIDMATCH_PARAMS} -d ${DATA_GRAPH} -q rdm/query_graphs/q${QUERY}.graph | python3 rdm/process.py
export QUERY=6; ${RAPIDMATCH_ISOMORPHIC_DIR}/build/matching/RapidMatch.out  ${RAPIDMATCH_PARAMS} -d ${DATA_GRAPH} -q rdm/query_graphs/q${QUERY}.graph | python3 rdm/process.py
