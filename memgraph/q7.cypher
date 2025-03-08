MATCH (:Tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]-(creator:Person)
OPTIONAL MATCH (message)<-[:LIKES]-(liker:Person)
OPTIONAL MATCH (message)<-[:REPLY_OF]-(comment:Comment)
RETURN count(*) AS count
