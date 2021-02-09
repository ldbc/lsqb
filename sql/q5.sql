SELECT count(*)
FROM person_isLocatedIn_place pilip1, person_isLocatedIn_place pilip2, person_isLocatedIn_place pilip3,
  place p1, place p2, place p3, place p4, place_isPartOf_place as pipop1, place_isPartOf_place as pipop2,
  place_isPartOf_place as pipop3, person_knows_person as pkp1, person_knows_person pkp2, person_knows_person pkp3
WHERE pilip1.PlaceId = p1.id
  AND p1.label = 'City'
  AND p1.id = pipop1.Place1Id
  AND pipop1.Place2Id = p4.id
  AND p4.label = 'Country'
  AND pilip2.PlaceId = p2.id
  AND p2.label = 'City'
  AND p2.id = pipop2.Place1Id
  AND pipop2.Place2Id = p4.id
  AND pilip3.PlaceId = p3.id
  AND p3.label = 'City'
  AND p3.id = pipop3.Place1Id
  AND pipop3.Place2Id = p4.id
  AND pilip1.PersonId = pkp1.Person1Id
  AND pilip2.PersonId = pkp1.Person2Id
  AND pilip2.PersonId = pkp2.Person1Id
  AND pilip3.PersonId = pkp2.Person2Id
  AND pilip3.PersonId = pkp3.Person1Id
  AND pilip1.PersonId = pkp3.Person2Id;
