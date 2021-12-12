MATCH
  (person1)-[:Person_knows_Person]->(person2)-[:Person_knows_Person]->(person3)-[:Person_knows_Person]->(person1),
  (person1:Person)-[:Person_isLocatedIn_City]->(city1:City)-[:City_isPartOf_Country]->(p1country:Country),
  (person2:Person)-[:Person_isLocatedIn_City]->(city2:City)-[:City_isPartOf_Country]->(p2country:Country),
  (person3:Person)-[:Person_isLocatedIn_City]->(city3:City)-[:City_isPartOf_Country]->(p3country:Country)
WHERE person1 <> person2
  AND person2 <> person3
  AND person1 <> person3
  AND p1country = p2country
  AND p2country = p3country
RETURN count(*)
