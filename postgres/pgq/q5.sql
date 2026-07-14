SELECT count(*)
FROM GRAPH_TABLE(lsqb
    MATCH (tag1 IS Tag)<-[ht IS Message_hasTag]-(m IS Message)<-[ro IS replyOf_Message]-(c IS Comment)-[ht1 IS Comment_hasTag]->(tag2 IS Tag)
    WHERE tag1.id <> tag2.id
    COLUMNS(1 AS c)
);
