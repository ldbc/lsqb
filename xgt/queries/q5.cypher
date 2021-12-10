MATCH (tag1:lsqb__Tag)<-[:lsqb__Comment_hasTag_Tag|lsqb__Post_hasTag_Tag]-(message:lsqb__Comment)<-[:lsqb__Comment_replyOf_Comment|lsqb__Comment_replyOf_Post]-(comment:lsqb__Comment)-[:lsqb__Comment_hasTag_Tag|lsqb__Post_hasTag_Tag]->(tag2:lsqb__Tag) // `message` can also be an lsqb__Post
WHERE tag1 <> tag2
RETURN count(*) AS count
