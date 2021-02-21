-- create a common table for the message nodes and edges starting from/ending in message nodes.
create view message as
  select id from comment
  union all
  select id from post;

create view Comment_replyOf_message as
  select CommentId, ParentCommentId as ParentMessageId from Comment_replyOf_Comment
  union all
  select CommentId, ParentPostId as ParentMessageId from Comment_replyOf_Post;

create view message_hasCreator_Person as
  select CommentId as MessageId, PersonId from Comment_hasCreator_Person
  union all
  select PostId as MessageId, PersonId from Post_hasCreator_Person;

create view message_hasTag_Tag as
  select CommentId as MessageId, TagId from Comment_hasTag_Tag
  union all
  select PostId as MessageId, TagId from Post_hasTag_Tag;

create view message_isLocatedIn_Place as
  select CommentId as MessageId, PlaceId from Comment_isLocatedIn_Place
  union all
  select PostId as MessageId, PlaceId from Post_isLocatedIn_Place;

create view Person_likes_message as
  select PersonId, CommentId as MessageId from Person_likes_Comment
  union all
  select PersonId, PostId as MessageId from Person_likes_Post;
