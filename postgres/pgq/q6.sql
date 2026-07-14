SELECT count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (person1 IS Person)-[k IS knows]-(person2 IS Person)-[k2 IS knows]-(person3 IS Person)-[hi IS hasInterest]->(T IS Tag)
    WHERE person1.id <> person3.id
    COLUMNS(1 AS c)
);
