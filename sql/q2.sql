SELECT count(*)
FROM Person_knows_Person
JOIN Comment
  ON Person_knows_Person.Person1Id = Comment.hasCreator_Person
JOIN Post
  ON Person_knows_Person.Person2Id = Post.hasCreator_Person
 AND Comment.replyOf_Post = Post.id;
