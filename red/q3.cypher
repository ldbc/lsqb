MATCH (tag1:Tag)<-[:HAS_TAG]-(message)<-[:REPLY_OF]-(comment:Comment)-[:HAS_TAG]->(tag2:Tag)
WHERE NOT (comment)-[:HAS_TAG]->(tag1)
  AND tag1 <> tag2
RETURN count(*) AS count
