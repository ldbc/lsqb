#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. kuz/vars.sh
. scripts/import-vars.sh

cd data/social-network-sf${SF}-projected-fk



if [ ! -f .converted ]; then
    echo "Creating CSV file Person_knows_Person_bidirectional.csv"
    cat Person_knows_Person.csv <(cat Person_knows_Person.csv | awk -F"|"  -v OFS="|" '{print($2, $1)}'| tail -n +2) > Person_knows_Person_bidirectional.csv

    CONVERSION_CANDIDATES=(\
        "Comment Post Message" \
        "Comment_hasCreator_Person Post_hasCreator_Person Message_hasCreator_Person" \
        "Comment_hasTag_Tag Post_hasTag_Tag Message_hasTag_Tag" \
        "Comment_isLocatedIn_Country Post_isLocatedIn_Country Message_isLocatedIn_Country" \
        "Comment_replyOf_Comment Comment_replyOf_Post Message_replyOf_Message"\
        "Person_likes_Comment Person_likes_Post Person_likes_Message" \
    )

    for CONVERSION_CANDIDATE in "${CONVERSION_CANDIDATES[@]}"; do
        IFS=' ' read -r -a CAND <<< "${CONVERSION_CANDIDATE[@]}"
        echo "Creating CSV file ${CAND[2]}.csv"
        cat ${CAND[0]}.csv <(tail -n +2 ${CAND[1]}.csv) > ${CAND[2]}.csv
    done

    # Forum_containerOf_Message always points to Posts
    cp Forum_containerOf_Post.csv Forum_containerOf_Message.csv

    touch .converted
fi
