MATCH (tag1:lsqb__Tag)
  <-[:lsqb__Post_hasTag_Tag]-(message:lsqb__Post)
  <-[:lsqb__Comment_replyOf_Post]-(comment:lsqb__Comment)
   -[:lsqb__Comment_hasTag_Tag]->(tag2:lsqb__Tag)
WHERE NOT (comment)-[:lsqb__Comment_hasTag_Tag]->(tag1)
  AND tag1 <> tag2
RETURN count(*) AS count
UNION ALL
MATCH (tag1:lsqb__Tag)
  <-[:lsqb__Comment_hasTag_Tag]-(message:lsqb__Comment)
  <-[:lsqb__Comment_replyOf_Comment]-(comment:lsqb__Comment)
   -[:lsqb__Comment_hasTag_Tag]->(tag2:lsqb__Tag)
WHERE NOT (comment)-[:lsqb__Comment_hasTag_Tag]->(tag1)
  AND tag1 <> tag2
RETURN count(*) AS count
