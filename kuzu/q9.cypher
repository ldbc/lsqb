MATCH (person1:Person)-[:Person_knows_Person]->(person2:Person)-[:Person_knows_Person]->(person3:Person)-[:Person_hasInterest_Tag]->(tag:Tag)
WHERE NOT (person1)-[k:Person_knows_Person]->(person3)
  AND id(person1) <> id(person3)
RETURN count(*) AS count
