WITH tmp AS (SELECT Post.PostId AS PostId, Post.Forum_containerOfId AS ForumId, Comment.CommentId AS CommentId, Comment_hasTag_Tag.TagId AS TagId
  FROM Comment
  JOIN Post
    ON Comment.replyOf_PostId = Post.PostId
  JOIN Comment_hasTag_Tag
    ON Comment.CommentId = Comment_hasTag_Tag.CommentId
)
SELECT count(*)
FROM tmp
JOIN Forum
  ON tmp.ForumId = Forum.ForumId
JOIN Forum_hasMember_Person
  ON Forum.ForumId = Forum_hasMember_Person.ForumId
JOIN Person
  ON Forum_hasMember_Person.PersonId = Person.PersonId
JOIN City
  ON Person.isLocatedIn_CityId = City.CityId
JOIN Tag
  ON Tag.TagId = tmp.TagId
JOIN TagClass
  ON Tag.hasType_TagClassId = TagClass.TagClassId
;
