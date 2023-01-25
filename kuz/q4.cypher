MATCH (:Tag)<-[:Message_hasTag_Tag]-(message:Post|Comment)-[:Message_hasCreator_Person]->(creator:Person),
  (message)<-[:Person_likes_Message]-(liker:Person),
  (message)<-[:Comment_replyOf_Message]-(comment:Comment)
RETURN count(*) AS count
