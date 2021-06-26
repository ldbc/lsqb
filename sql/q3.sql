SELECT count(*)
FROM Country
JOIN City AS CityA
  ON CityA.isPartOf_CountryId = Country.CountryId
JOIN City AS CityB
  ON CityB.isPartOf_CountryId = Country.CountryId
JOIN City AS CityC
  ON CityC.isPartOf_CountryId = Country.CountryId
JOIN Person AS PersonA
  ON PersonA.isLocatedIn_CityId = CityA.CityId
JOIN Person AS PersonB
  ON PersonB.isLocatedIn_CityId = CityB.CityId
JOIN Person AS PersonC
  ON PersonC.isLocatedIn_CityId = CityC.CityId
JOIN Person_knows_Person AS pkp1
  ON pkp1.Person1Id = personA.PersonId
 AND pkp1.Person2Id = personB.PersonId
JOIN Person_knows_Person AS pkp2
  ON pkp2.Person1Id = personB.PersonId
 AND pkp2.Person2Id = personC.PersonId
JOIN Person_knows_person AS pkp3
  ON pkp3.Person1Id = personC.PersonId
 AND pkp3.Person2Id = personA.PersonId;
