MATCH p=(tag1:Tag)<-[:HAS_TAG]-(message)<-[:REPLY_OF]-(comment:Comment)-[:HAS_TAG]->(tag2:Tag)
WHERE tag1 <> tag2
RETURN count(p) AS count
