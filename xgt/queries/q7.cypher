MATCH (tag:lsqb__Tag)<-[:lsqb__Post_hasTag_Tag]-(message:lsqb__Post)-[:lsqb__Post_hasCreator_Person]->(creator:lsqb__Person)
OPTIONAL MATCH
  (message)<-[:lsqb__Person_likes_Post]-(liker:lsqb__Person),
  (message)<-[:lsqb__Comment_replyOf_Post]-(comment:lsqb__Comment)
RETURN count(*) AS count
UNION ALL
MATCH (tag:lsqb__Tag)<-[:lsqb__Comment_hasTag_Tag]-(message:lsqb__Comment)-[:lsqb__Comment_hasCreator_Person]->(creator:lsqb__Person)
OPTIONAL MATCH
  (message)<-[:lsqb__Person_likes_Comment]-(liker:lsqb__Person),
  (message)<-[:lsqb__Comment_replyOf_Comment]-(comment:lsqb__Comment)
RETURN count(*) AS count
