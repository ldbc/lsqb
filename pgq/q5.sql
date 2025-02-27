SELECT count(*)
FROM GRAPH_TABLE(lsqb
    MATCH (tag1:Tag) < -[ht:Message_hasTag]-(m:Message)<-[ro:replyOf_Message]-(c :Comment)-[ht1:Comment_hasTag]->(tag2:Tag)
    WHERE tag1.id <> tag2.id
);
