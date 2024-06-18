MATCH (tag1:Tag)<-[:Message_hasTag_Tag]-(message:Message)<-[:Message_replyOf_Message]-(comment:Message)-[:Message_hasTag_Tag]->(tag2:Tag)
OPTIONAL MATCH (comment)-[h:Message_hasTag_Tag]->(tag1)
WHERE h IS NULL
  AND tag1.TagId <> tag2.TagId
RETURN count(*) AS count
