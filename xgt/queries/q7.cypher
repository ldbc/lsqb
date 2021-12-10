MATCH (:lsqb__Tag)<-[:lsqb__Message_hasTag_Tag]-(message:lsqb__Message)-[:lsqb__Message_hasCreator_Person]->(creator:lsqb__Person)
OPTIONAL MATCH (message)<-[:lsqb__Person_likes_Message]-(liker:lsqb__Person)
OPTIONAL MATCH (message)<-[:lsqb__Comment_replyOf_Message]-(comment:lsqb__Comment)
RETURN count(*) AS count
