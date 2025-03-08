MATCH (:Tag)<-[:Message_hasTag_Tag]-(message:Message)-[:Message_hasCreator_Person]->(creator:Person),
  (message)<-[:Person_likes_Message]-(liker:Person),
  (message)<-[:Message_replyOf_Message]-(comment:Message)
RETURN count(*) AS count
