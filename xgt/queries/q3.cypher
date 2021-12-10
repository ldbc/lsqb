MATCH
  (person1)-[:lsqb__Person_knows_Person]->(person2)-[:lsqb__Person_knows_Person]->(person3)-[:lsqb__Person_knows_Person]->(person1),
  (person1:lsqb__Person)-[:lsqb__Person_isLocatedIn_City]->(city1:lsqb__City)-[:lsqb__City_isPartOf_Country]->(p1country:lsqb__Country),
  (person2:lsqb__Person)-[:lsqb__Person_isLocatedIn_City]->(city2:lsqb__City)-[:lsqb__City_isPartOf_Country]->(p2country:lsqb__Country),
  (person3:lsqb__Person)-[:lsqb__Person_isLocatedIn_City]->(city3:lsqb__City)-[:lsqb__City_isPartOf_Country]->(p3country:lsqb__Country)
WHERE person1 <> person2
  AND person2 <> person3
  AND person1 <> person3
  AND p1country = p2country
  AND p2country = p3country
RETURN count(*)
