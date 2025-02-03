SELECT count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (t:tag)<-[mht:Message_hasTag]-(message:Message)-[mhc:Message_hasCreator]->(creator:Person)
) g
LEFT JOIN Comment_replyOf_Message crom on g.MessageId = crom.messageId
LEFT JOIN Person_likes_Message plm on g.MessageId = plm.messageId;