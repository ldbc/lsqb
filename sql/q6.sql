WITH foaf AS (
SELECT pkp1.Person1Id AS p1id, pkp1.Person2Id AS p2id, pkp2.Person2Id AS p3id
  FROM Person_knows_Person pkp1
  JOIN Person_knows_Person pkp2
    ON pkp1.Person2Id = pkp2.Person1Id
   AND pkp1.Person1Id != pkp2.Person2Id
)
SELECT count(*)
FROM foaf
JOIN Person_hasInterest_Tag
  ON Person_hasInterest_Tag.PersonId = foaf.p3id
;
