MATCH (tag1:Tag)<-[:HAS_TAG]-(message:Message)<-[:REPLY_OF]-(comment:Comment)-[:HAS_TAG]->(tag2:Tag)
WHERE tag1 <> tag2
OPTIONAL MATCH (comment)-[hT:HAS_TAG]->(tag1)
WITH tag1, hT
WHERE hT IS NULL
RETURN count(*) AS count
