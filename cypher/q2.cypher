MATCH (:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]-(:Person)
OPTIONAL MATCH (m)<-[:LIKES]-(lp:Person)
OPTIONAL MATCH (m)<-[:REPLY_OF]-(rc:Comment)
RETURN count(*) AS count
