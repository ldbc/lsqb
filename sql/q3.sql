WITH person_city AS (SELECT Person.PersonId AS PersonId, City.CityId AS CityId
  FROM Person
  JOIN City
    ON City.CityId = Person.isLocatedIn_CityId
),
  person_pairs AS (    
  SELECT knows.Person1Id AS Person1Id, knows.Person2Id AS Person2Id, person_city1.CityId AS City1Id, person_city2.CityId AS City2Id
    FROM Person_knows_Person AS knows
    JOIN person_city person_city1
      ON person_city1.PersonId = knows.Person1Id
    JOIN person_city person_city2
      ON person_city2.PersonId = knows.Person2Id
  ),
  edge AS (SELECT person_pairs.Person1Id AS p1, person_pairs.Person2Id AS p2, City1.isPartOf_CountryId AS country
  FROM person_pairs
  JOIN City City1
    ON City1.CityId = City1Id
  JOIN City City2
    ON City2.CityId = City2Id
  WHERE City1.isPartOf_CountryId = City2.isPartOf_CountryId    
  ),
  wedges AS (SELECT
    edge1.p1 AS p1,
    edge2.p2 AS p3,
    edge2.country AS country
  FROM edge edge1
  JOIN edge edge2
  ON edge1.p2 = edge2.p1
 AND edge1.country = edge2.country
)
SELECT count(*)
FROM wedges
JOIN edge edge3
  ON wedges.p3 = edge3.p1
 AND edge3.p2 = wedges.p1
 AND wedges.country = edge3.country
;
