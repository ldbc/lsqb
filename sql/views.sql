-- create a common table for the message nodes and edges starting from/ending in message nodes.
CREATE VIEW Message AS
  SELECT id FROM Comment
  UNION ALL
  SELECT id FROM Post;

CREATE VIEW Comment_replyOf_Message AS
  SELECT id AS CommentId, replyOf_Post AS ParentMessageId FROM Comment
  where replyOf_Post IS NOT NULL
  UNION ALL
  SELECT id AS CommentId, replyOf_Comment AS ParentMessageId FROM Comment
  where replyOf_Comment IS NOT NULL;

CREATE VIEW Message_hasCreator_Person AS
  SELECT id AS MessageId, hasCreator_Person FROM Comment
  UNION ALL
  SELECT id AS MessageId, hasCreator_Person FROM Post;

CREATE VIEW Message_hasTag_Tag AS
  SELECT id AS MessageId, hasTag_Tag FROM Comment_hasTag_Tag
  UNION ALL
  SELECT id AS MessageId, hasTag_Tag FROM Post_hasTag_Tag;

CREATE VIEW Message_isLocatedIn_Country AS
  SELECT id AS MessageId, isLocatedIn_Country FROM Comment
  UNION ALL
  SELECT id AS MessageId, isLocatedIn_Country FROM Post;

CREATE VIEW Person_likes_Message AS
  SELECT id AS PersonId, likes_Comment AS MessageId FROM Person_likes_Comment
  UNION ALL
  SELECT id AS PersonId, likes_Post AS MessageId FROM Person_likes_Post;
