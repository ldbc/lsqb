MATCH
    (personA:Person)-[:KNOWS]-(personB:Person),
    (personA)<-[:HAS_CREATOR]-(comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(personB)
RETURN count(*) AS count
