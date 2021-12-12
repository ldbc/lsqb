MATCH (person1:Person)
  -[:Person_knows_Person]->(person2:Person)
  -[:Person_knows_Person]->(person3:Person)
  -[:Person_hasInterest_Tag]->(tag:Tag)
WHERE person1 <> person3
RETURN count(*) AS count
