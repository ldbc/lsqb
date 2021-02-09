SELECT count(*)
FROM person_knows_person pkp1, person_knows_person pkp2, person_hasInterest_tag
WHERE pkp1.Person2Id = pkp2.Person1Id
  AND pkp2.Person2Id = person_hasInterest_tag.PersonId
  AND pkp1.Person1Id != pkp2.Person2Id
  AND NOT EXISTS (SELECT 1 from person_knows_person pkp3
    WHERE pkp3.Person2Id = pkp2.Person2Id 
      AND pkp3.Person1Id = pkp1.Person1Id);
