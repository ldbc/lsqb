MATCH (tag:Tag)<-[:Post_hasTag_Tag]-(message:Post)-[:Post_hasCreator_Person]->(creator:Person)
OPTIONAL MATCH
  (message)<-[:Person_likes_Post]-(liker:Person),
  (message)<-[:Comment_replyOf_Post]-(comment:Comment)
RETURN count(*) AS count
UNION ALL
MATCH (tag:Tag)<-[:Comment_hasTag_Tag]-(message:Comment)-[:Comment_hasCreator_Person]->(creator:Person)
OPTIONAL MATCH
  (message)<-[:Person_likes_Comment]-(liker:Person),
  (message)<-[:Comment_replyOf_Comment]-(comment:Comment)
RETURN count(*) AS count
