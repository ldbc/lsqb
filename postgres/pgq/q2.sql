SELECT count(*)
FROM GRAPH_TABLE(lsqb
    MATCH (p1 IS Person)-[k IS knows]-(p2 IS Person)
    COLUMNS (p1.id AS p1_id, p2.id AS p2_id)
) knows_gt
JOIN GRAPH_TABLE(lsqb
    MATCH (p1 IS Person)<-[hc IS Comment_hasCreator]-(co IS Comment)-[rop IS replyOf_Post]->(po IS Post)-[pc IS Post_hasCreator]->(p2 IS Person)
    COLUMNS (p1.id AS p1_id, p2.id AS p2_id)
) reply_gt
ON knows_gt.p1_id = reply_gt.p1_id AND knows_gt.p2_id = reply_gt.p2_id;