MATCH
  (:lsqb__Tag)<-[]-(message)-[]->(creator:lsqb__Person),
    // :lsqb__Message_hasTag_Tag
    // :lsqb__Message_hasCreator_Person
  (message)<-[]-(liker:lsqb__Person), // :lsqb__Person_likes_Message
  (message)<-[]-(comment:lsqb__Comment) // :lsqb__Comment_replyOf_Message
RETURN count(*) AS count
