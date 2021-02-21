SELECT count(*)
FROM Person_knows_Person, Comment, Post
WHERE Person_knows_Person.Person1Id = Comment.hasCreator_Person
  AND Person_knows_Person.Person2Id = Post.hasCreator_Person
  AND Comment.replyOf_Post = Post.id;
