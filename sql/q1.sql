SELECT count(*)
FROM Country
JOIN City
  ON City.isPartOf_CountryId = Country.CountryId
JOIN Person
  ON Person.isLocatedIn_CityId = City.CityId
JOIN Forum_hasMember_Person
  ON Forum_hasMember_Person.PersonId = Person.PersonId
JOIN Forum
  ON Forum.ForumId = Forum_hasMember_Person.ForumId
JOIN Post
  ON Post.Forum_containerOfId = Forum.ForumId
JOIN Comment
  ON Comment.replyOf_PostId = Post.PostId
JOIN Comment_hasTag_Tag
  ON Comment_hasTag_Tag.CommentId = Comment.CommentId
JOIN Tag
  ON Tag.TagId = Comment_hasTag_Tag.TagId
JOIN TagClass
  ON Tag.hasType_TagClassId = TagClass.TagClassId;
