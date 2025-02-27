SELECT count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (t:Tag)<-[mht:Message_hasTag]-(message:Message)-[hc:message_hasCreator]->(creator:Person),
        (message:message)<-[lm:likes_message]-(liker:Person),
        (message:message)<-[rpo:replyOf_Message]-(c:Comment)
    )

