SELECT count(*)
FROM place_isPartOf_place, place p1, place p2, person_isLocatedIn_place, forum_hasModerator_person,
  forum_containerOf_post, comment_replyOf_post, comment_hasTag_tag, tag_hasType_tagclass  
WHERE place_isPartOf_place.Place1Id = p1.id
  AND p1.label = 'City'
  AND place_isPartOf_place.Place2Id = p2.id
  AND p2.label = 'Country'
  AND person_isLocatedIn_place.PlaceId = place_isPartOf_place.Place1Id
  AND forum_hasModerator_person.PersonId = person_isLocatedIn_place.PersonId
  AND forum_containerOf_post.ForumId = forum_hasModerator_person.ForumId
  AND forum_containerOf_post.PostId = comment_replyOf_post.ParentPostId
  AND comment_hasTag_tag.CommentId =  comment_replyOf_post.CommentId
  AND comment_hasTag_tag.TagId = tag_hasType_tagclass.TagId;
