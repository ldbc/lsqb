select count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (p1:Person)-[k:knows]-(p2:Person),
    (p1:Person)<-[hc:Comment_hasCreator]-(co:Comment)-[rop:replyOf_Post]->(po:Post)-[pc:Post_hasCreator]->(p2:Person)
    COLUMNS(*)
);
