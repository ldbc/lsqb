MATCH
  (person1:Person)
    -[:Person_knows_Person]->(person2:Person)
    -[:Person_knows_Person]->(person3:Person)
    -[:Person_hasInterest_Tag]->(tag:Tag)
WHERE NOT (person1)-[:Person_knows_Person]->(person3)
  AND person1 <> person3
RETURN count(*) AS count
