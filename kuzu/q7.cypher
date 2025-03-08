MATCH (:Tag)<-[:Message_hasTag_Tag]-(message:Message)-[:Message_hasCreator_Person]->(creator:Person)
OPTIONAL MATCH (message)<-[:Person_likes_Message]-(liker:Person)
OPTIONAL MATCH (message)<-[:Message_replyOf_Message]-(comment:Message)
RETURN count(*) AS count
