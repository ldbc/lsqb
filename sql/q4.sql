SELECT count(*)
FROM Person_knows_Person, Comment_hasCreator_Person, Comment_replyOf_Post, Post_hasCreator_Person
WHERE Person_knows_Person.Person1Id = Comment_hasCreator_Person.PersonId
  AND Comment_hasCreator_Person.CommentId = Comment_replyOf_Post.CommentId
  AND Comment_replyOf_Post.ParentPostId = Post_hasCreator_Person.PostId
  AND Post_hasCreator_Person.PersonId = Person_knows_Person.Person2Id;
