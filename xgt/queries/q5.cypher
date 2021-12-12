MATCH (tag1:Tag)<-[:Post_hasTag_Tag]-(message:Post)<-[:Comment_replyOf_Post]-(comment:Comment)-[:Comment_hasTag_Tag]->(tag2:Tag)
WHERE tag1 <> tag2
RETURN count(*) AS count
UNION ALL
MATCH (tag1:Tag)<-[:Comment_hasTag_Tag]-(message:Comment)<-[:Comment_replyOf_Comment]-(comment:Comment)-[:Comment_hasTag_Tag]->(tag2:Tag)
WHERE tag1 <> tag2
RETURN count(*) AS count
