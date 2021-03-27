MATCH p=(:Country)<-[:IS_PART_OF]-(:City)<-[:IS_LOCATED_IN]-(:Person)<-[:HAS_MEMBER]-(:Forum)-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF]-()-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(:TagClass)
RETURN count(p) AS count
