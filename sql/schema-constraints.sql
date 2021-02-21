-- create a common table for the message nodes and edges starting from/ending in message nodes.
create view Message as
  select id from Comment
  union all
  select id from Post;

create view Comment_replyOf_Message as
  select id AS CommentId, replyOf_Post AS ParentMessageId from Comment
  where replyOf_Post IS NOT NULL
  union all
  select id AS CommentId, replyOf_Comment AS ParentMessageId from Comment
  where replyOf_Comment IS NOT NULL;

create view Message_hasCreator_Person as
  select id as MessageId, hasCreator_Person from Comment
  union all
  select id as MessageId, hasCreator_Person from Post;

create view Message_hasTag_Tag as
  select id as MessageId, hasTag_Tag from Comment_hasTag_Tag
  union all
  select id as MessageId, hasTag_Tag from Post_hasTag_Tag;

create view Message_isLocatedIn_Place as
  select id as MessageId, isLocatedIn_Place from Comment
  union all
  select id as MessageId, isLocatedIn_Place from Post;

create view Person_likes_Message as
  select id as PersonId, likes_Comment as MessageId from Person_likes_Comment
  union all
  select id as PersonId, likes_Post as MessageId from Person_likes_Post;
