SELECT count(*)
FROM GRAPH_TABLE(lsqb
    MATCH (tag1:Tag)<-[ht:Message_hasTag]-(m:Message)<-[ro:replyOf_Message]-(c:Comment)-[ht1:Comment_hasTag]->(tag2:Tag)
    COLUMNS (tag1.id as TagId_1, c.id as CommentId, tag2.id as TagId)
) g
LEFT JOIN Comment_hasTag_Tag AS cht2
       ON g.TagId_1 = cht2.TagId
      AND g.CommentId = cht2.CommentId
    WHERE g.TagId != g.TagId_1
      AND cht2.TagId IS NULL;
