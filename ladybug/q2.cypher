MATCH
  (person1:Person)-[:Person_knows_Person]->(person2:Person),
  (person1)<-[:Message_hasCreator_Person]-(comment:Message)-[:Comment_replyOf_Post]->(Post:Message)-[:Message_hasCreator_Person]->(person2)
RETURN count(*) AS count
