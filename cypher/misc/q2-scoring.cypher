MATCH (tag:Tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]-(creator:Person)
OPTIONAL MATCH (message)<-[:LIKES]-(liker:Person)
OPTIONAL MATCH (message)<-[:REPLY_OF]-(comment:Comment)
RETURN (count(message)+count(liker)+count(comment)) / count(tag) AS
