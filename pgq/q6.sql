SELECT count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (person1:Person)-[k:knows]-(person2:Person)-[k2:knows]-(person3:Person)-[hi:hasInterest]->(T:Tag)
    WHERE person1.id <> person3.id
);
