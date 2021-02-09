SELECT count(*)
FROM person_knows_person pkp1
JOIN person_knows_person pkp2
  ON pkp1.Person2Id = pkp2.Person1Id
 AND pkp1.Person1Id != pkp2.Person2Id
JOIN person_hasInterest_tag
  ON pkp2.Person2Id = person_hasInterest_tag.PersonId
LEFT JOIN person_knows_person pkp3
       ON pkp3.Person1Id = pkp1.Person1Id
      AND pkp3.Person2Id = pkp2.Person2Id
    WHERE pkp3.Person1Id IS NULL;
