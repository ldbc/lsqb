SELECT count(*)
FROM
  City AS CityA,
  City AS CityB,
  City AS CityC,
  Person AS personA,
  Person AS personB,
  Person AS personC,
  Person_knows_Person AS pkp1,
  Person_knows_Person AS pkp2,
  Person_knows_Person AS pkp3
WHERE CityB.isPartOf_Country = CityA.isPartOf_Country
  AND CityC.isPartOf_Country = CityA.isPartOf_Country
  AND personA.isLocatedIn_Place = CityA.id
  AND personB.isLocatedIn_Place = CityB.id
  AND personC.isLocatedIn_Place = CityC.id
  AND personA.id = pkp1.Person1Id
  AND personB.id = pkp2.Person1Id
  AND personC.id = pkp3.Person1Id
  AND pkp1.Person2Id = pkp2.Person1Id
  AND pkp2.Person2Id = pkp3.Person1Id
  AND pkp3.Person2Id = pkp1.Person1Id;
