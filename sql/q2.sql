SELECT count(*)
FROM Person_knows_Person
JOIN Comment
  ON Person_knows_Person.Person1Id = Comment.hasCreator_PersonId
JOIN Post
  ON Person_knows_Person.Person2Id = Post.hasCreator_PersonId
 AND Comment.replyOf_PostId = Post.PostId;
