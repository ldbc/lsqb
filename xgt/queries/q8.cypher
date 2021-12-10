MATCH (tag1:lsqb__Tag)
  <-[:lsqb__Message_hasTag_Tag]-(message:lsqb__Message)
  <-[:lsqb__Comment_replyOf_Message]-(comment:lsqb__Comment)
   -[:lsqb__Comment_hasTag_Tag]->(tag2:lsqb__Tag)
WHERE NOT (comment)-[:lsqb__Comment_hasTag_Tag]->(tag1)
  AND tag1 <> tag2
RETURN count(*) AS count
