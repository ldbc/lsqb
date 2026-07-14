WITH mc AS (
    SELECT mid
    FROM GRAPH_TABLE (lsqb
        MATCH (t IS Tag)<-[mht IS Message_hasTag]-(m IS Message)-[hc IS message_hasCreator]->(creator IS Person)
        COLUMNS (m.id AS mid)
    )
),
ml AS (
    SELECT mid
    FROM GRAPH_TABLE (lsqb
        MATCH (m IS Message)<-[lm IS likes_message]-(liker IS Person)
        COLUMNS (m.id AS mid)
    )
),
mr AS (
    SELECT mid
    FROM GRAPH_TABLE (lsqb
        MATCH (m IS Message)<-[rpo IS replyOf_Message]-(c IS Comment)
        COLUMNS (m.id AS mid)
    )
)
SELECT count(*) FROM mc
JOIN ml USING (mid)
JOIN mr USING (mid);