SELECT count(*)
FROM
  Person_isLocatedIn_Place AS pilipA,
  Person_isLocatedIn_Place AS pilipB,
  Person_isLocatedIn_Place AS pilipC,
  City_isPartOf_Country AS CityA_isPartOf_Country,
  City_isPartOf_Country AS CityB_isPartOf_Country,
  City_isPartOf_Country AS CityC_isPartOf_Country,
  Person_knows_Person AS pkp1,
  Person_knows_Person AS pkp2,
  Person_knows_Person AS pkp3
WHERE CityB_isPartOf_Country.CountryId = CityA_isPartOf_Country.CountryId
  AND CityC_isPartOf_Country.CountryId = CityA_isPartOf_Country.CountryId
  AND pilipA.PlaceId = CityA_isPartOf_Country.CityId
  AND pilipB.PlaceId = CityB_isPartOf_Country.CityId
  AND pilipC.PlaceId = CityC_isPartOf_Country.CityId
  AND pilipA.PersonId = pkp1.Person1Id
  AND pilipB.PersonId = pkp2.Person1Id
  AND pilipC.PersonId = pkp3.Person1Id
  AND pkp1.Person2Id = pkp2.Person1Id
  AND pkp2.Person2Id = pkp3.Person1Id
  AND pkp3.Person2Id = pkp1.Person1Id;
