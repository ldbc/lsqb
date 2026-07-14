SELECT count(*)
FROM GRAPH_TABLE (lsqb
  MATCH (person1 IS Person)-[k IS knows]-(person2 IS Person)-[k2 IS knows]-(person3 IS Person)-[hi IS hasInterest]->(T IS Tag)
  WHERE person1.id <> person3.id
  COLUMNS (person1.id as p1_id, person3.id as p3_id)
) g
LEFT JOIN (select person1id, person2id FROM Person_knows_Person UNION ALL select person2id, person1id from Person_knows_person) pkp3
       ON pkp3.Person1Id = g.p1_id
      AND pkp3.Person2Id = g.p3_id
    WHERE pkp3.Person1Id IS NULL;
