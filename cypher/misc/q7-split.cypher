MATCH (:Tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]-(creator:Person)
WITH message, count(*) AS cm
OPTIONAL MATCH (message)<-[:LIKES]-(liker:Person)
WITH message, cm, count(liker) AS cl
OPTIONAL MATCH (message)<-[:REPLY_OF]-(comment:Comment)
WITH message, cm, cl, count(comment) AS cc
RETURN sum(cm
    * (CASE cl WHEN 0 THEN 1 ELSE cl END)
    * (CASE cc WHEN 0 THEN 1 ELSE cc END)
  ) AS count
