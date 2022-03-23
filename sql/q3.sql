WITH edge AS (SELECT knows.Person1Id AS p1, knows.Person2Id AS p2, City1.isPartOf_CountryId AS country
  FROM Person_knows_Person AS knows
  JOIN Person Person1
    ON Person1.PersonId = knows.Person1Id
  JOIN City City1
    ON City1.CityId = Person1.isLocatedIn_CityId
  JOIN Person Person2
    ON Person2.PersonId = knows.Person2Id
  JOIN City City2
    ON City2.CityId = Person2.isLocatedIn_CityId
  WHERE City1.isPartOf_CountryId = City2.isPartOf_CountryId
  )
SELECT count(*)
FROM edge edge1
JOIN edge edge2
  ON edge1.p2 = edge2.p1
 AND edge1.country = edge2.country
JOIN edge edge3
  ON edge2.p2 = edge3.p1
 AND edge3.p2 = edge1.p1
 AND edge2.country = edge3.country
;
