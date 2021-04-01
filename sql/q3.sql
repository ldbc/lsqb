SELECT count(*)
FROM Country
JOIN City AS CityA
  ON CityA.isPartOf_Country = Country.id
JOIN City AS CityB
  ON CityB.isPartOf_Country = Country.id
JOIN City AS CityC
  ON CityC.isPartOf_Country = Country.id
JOIN Person AS PersonA
  ON PersonA.isLocatedIn_City = CityA.id
JOIN Person AS PersonB
  ON PersonB.isLocatedIn_City = CityB.id
JOIN Person AS PersonC
  ON PersonC.isLocatedIn_City = CityC.id
JOIN Person_knows_Person AS pkp1
  ON pkp1.Person1Id = personA.id
 AND pkp1.Person2Id = personB.id
JOIN Person_knows_Person AS pkp2
  ON pkp2.Person1Id = personB.id
 AND pkp2.Person2Id = personC.id
JOIN Person_knows_person AS pkp3
  ON pkp3.Person1Id = personC.id
 AND pkp3.Person2Id = personA.id;
