MATCH (:Country)<-[:City_isPartOf_Country]-(:City)<-[:City_isLocatedIn_Person]-(:Person)<-[:Forum_hasMember_Person]-(:Forum)-[:Forum_containerOf_Post]->(:Post)<-[:Comment_replyOf_Post]-(:Comment)-[:Comment_hasTag_Tag]->(:Tag)-[:Tag_hasType_TagClass]->(:TagClass)
RETURN count(*) AS count
