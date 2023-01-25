MATCH (:Country)<-[:City_isPartOf_Country]-(:City)<-[:Person_isLocatedIn_City]-(:Person)<-[:Forum_hasMember_Person]-(:Forum)-[:Forum_containerOf_Message]->(:Message)<-[:Message_replyOf_Message]-(:Message)-[:Message_hasTag_Tag]->(:Tag)-[:Tag_hasType_TagClass]->(:TagClass)
RETURN count(*) AS count
