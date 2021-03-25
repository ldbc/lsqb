MATCH (person1:Person)-[:KNOWS]-(mutualFriend:Person)-[:KNOWS]-(person2:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE person1 <> person2
RETURN count(*) AS count
