SELECT count(*)
FROM person_knows_person, comment_hasCreator_person, comment_replyOf_post, post_hasCreator_person
WHERE person_knows_person.Person1Id = comment_hasCreator_person.PersonId
  AND comment_hasCreator_person.CommentId = comment_replyOf_post.CommentId
  AND comment_replyOf_post.ParentPostId = post_hasCreator_person.PostId
  AND post_hasCreator_person.PersonId = person_knows_person.Person2Id;
