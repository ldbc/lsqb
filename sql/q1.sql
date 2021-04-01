SELECT count(*)
FROM Country
JOIN City
  ON City.isPartOf_Country = Country.id
JOIN Person
  ON Person.isLocatedIn_City = City.id
JOIN Forum_hasMember_Person
  ON Forum_hasMember_Person.hasMember_Person = Person.id
JOIN Forum
  ON Forum.id = Forum_hasMember_Person.id
JOIN Post
  ON Post.Forum_containerOf = Forum.id
JOIN Comment
  ON Comment.replyOf_Post = Post.id
JOIN Comment_hasTag_Tag
  ON Comment_hasTag_Tag.id = Comment.id
JOIN Tag
  ON Tag.id = Comment_hasTag_Tag.hasTag_Tag
JOIN TagClass
  ON Tag.hasType_TagClass = TagClass.id;
