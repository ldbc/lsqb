SELECT count(*)
FROM City_isPartOf_Country, Country, City, Person_isLocatedIn_Place, Forum_hasModerator_Person,
  Forum_containerOf_Post, Comment_replyOf_Post, Comment_hasTag_Tag, Tag_hasType_TagClass  
WHERE City_isPartOf_Country.CityId = City.id
  AND City_isPartOf_Country.CountryId = Country.id
  AND Person_isLocatedIn_Place.PlaceId = City_isPartOf_Country.CityId
  AND Forum_hasModerator_Person.PersonId = Person_isLocatedIn_Place.PersonId
  AND Forum_containerOf_Post.ForumId = Forum_hasModerator_Person.ForumId
  AND Forum_containerOf_Post.PostId = Comment_replyOf_Post.ParentPostId
  AND Comment_hasTag_Tag.CommentId =  Comment_replyOf_Post.CommentId
  AND Comment_hasTag_Tag.TagId = Tag_hasType_TagClass.TagId;
