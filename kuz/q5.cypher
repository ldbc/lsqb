MATCH (tag1:Tag)<-[:Message_hasTag_Tag]-(message:Message)<-[:Comment_replyOf_Message]-(comment:Comment)-[:Comment_hasTag_Tag]->(tag2:Tag)
WHERE tag1 <> tag2
RETURN count(*) AS count