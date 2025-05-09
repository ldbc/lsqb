SELECT count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (t:tag)<-[mht:Message_hasTag]-(message:Message)-[mhc:Message_hasCreator]->(creator:Person)
    COLUMNS(message.id as messageId)
) g
LEFT JOIN Comment_replyOf_Message crom ON g.MessageId = crom.messageId
LEFT JOIN Person_likes_Message plm ON g.MessageId = plm.messageId;
