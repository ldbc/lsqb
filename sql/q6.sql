SELECT count(*)
FROM Person_knows_Person pkp1
JOIN Person_knows_Person pkp2
  ON pkp1.Person2Id = pkp2.Person1Id
 AND pkp1.Person1Id != pkp2.Person2Id
JOIN Person_hasInterest_Tag
  ON pkp2.Person2Id = Person_hasInterest_Tag.PersonId
LEFT JOIN Person_knows_Person pkp3
       ON pkp3.Person1Id = pkp1.Person1Id
      AND pkp3.Person2Id = pkp2.Person2Id
    WHERE pkp3.Person1Id IS NULL;
