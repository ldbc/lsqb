MATCH
  (:lsqb__Country)
    <-[:lsqb__City_isPartOf_Country]-(:lsqb__City)
    <-[:lsqb__Person_isLocatedIn_City]-(:lsqb__Person)
    <-[:lsqb__Forum_hasMember_Person]-(:lsqb__Forum)
     -[:lsqb__Forum_containerOf_Post]->(:lsqb__Post)
    <-[:lsqb__Comment_replyOf_Post]-(:lsqb__Comment)
     -[:lsqb__Comment_hasTag_Tag]->(:lsqb__Tag)
     -[:lsqb__Tag_hasType_TagClass]->(:lsqb__TagClass)
RETURN count(*) AS count
