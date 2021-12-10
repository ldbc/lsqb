MATCH
  (person1:lsqb__Person)
    -[:lsqb__Person_knows_Person]->(person2:lsqb__Person)
    -[:lsqb__Person_knows_Person]->(person3:lsqb__Person)
    -[:lsqb__Person_hasInterest_Tag]->(tag:lsqb__Tag)
WHERE NOT (person1)-[:lsqb__Person_knows_Person]->(person3)
  AND person1 <> person3
RETURN count(*) AS count
