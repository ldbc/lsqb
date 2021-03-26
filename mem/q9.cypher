MATCH (person1:Person)-[:KNOWS]-(mutualFriend:Person)-[:KNOWS]-(person2:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE person1 <> person2
OPTIONAL MATCH (person1)-[k:KNOWS]-(person2)
WITH person1, k
WHERE k IS NULL
RETURN count(*) AS count
