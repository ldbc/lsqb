MATCH
  (person1:lsqb__Person)-[:lsqb__Person_knows_Person]->(person2:lsqb__Person),
  (person1)<-[:lsqb__Comment_hasCreator_Person]-(comment:lsqb__Comment)
            -[:lsqb__Comment_replyOf_Post]->(post:lsqb__Post)
            -[:lsqb__Post_hasCreator_Person]->(person2)
RETURN count(*) AS count
