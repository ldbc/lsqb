-- create a common table for the message nodes and edges starting from/ending in message nodes.
create view message as
  select id from comment
  union all
  select id from post;

create view comment_replyOf_message as
  select CommentId, ParentCommentId as ParentMessageId from comment_replyOf_comment
  union all
  select CommentId, ParentPostId as ParentMessageId from comment_replyOf_post;

create view message_hasCreator_person as
  select CommentId as MessageId, PersonId from comment_hasCreator_person
  union all
  select PostId as MessageId, PersonId from post_hasCreator_person;

create view message_hasTag_tag as
  select CommentId as MessageId, TagId from comment_hasTag_tag
  union all
  select PostId as MessageId, TagId from post_hasTag_tag;

create view message_isLocatedIn_place as
  select CommentId as MessageId, PlaceId from comment_isLocatedIn_place
  union all
  select PostId as MessageId, PlaceId from post_isLocatedIn_place;

create view person_likes_message as
  select PersonId, CommentId as MessageId from person_likes_comment
  union all
  select PersonId, PostId as MessageId from person_likes_post;

-- create index tagclass_isSubclassOf_tagclass_TagClass1Id on tagclass_isSubclassOf_tagclass(TagClass1Id);
-- create index tagclass_isSubclassOf_tagclass_TagClass2Id on tagclass_isSubclassOf_tagclass(TagClass2Id);
-- create index tag_hasType_tagclass_TagId on tag_hasType_tagclass(TagId);
-- create index tag_hasType_tagclass_TagClassId on tag_hasType_tagclass(TagClassId);
-- create index organisation_isLocatedIn_place_OrganisationId on organisation_isLocatedIn_place(OrganisationId);
-- create index organisation_isLocatedIn_place_PlaceId on organisation_isLocatedIn_place(PlaceId);
-- create index place_isPartOf_place_Place1Id on place_isPartOf_place(Place1Id);
-- create index place_isPartOf_place_Place2Id on place_isPartOf_place(Place2Id);
-- create index comment_hasCreator_person_CommentId on comment_hasCreator_person(CommentId);
-- create index comment_hasCreator_person_PersonId on comment_hasCreator_person(PersonId);
-- create index comment_hasTag_tag_CommentId on comment_hasTag_tag(CommentId);
-- create index comment_hasTag_tag_TagId on comment_hasTag_tag(TagId);
-- create index comment_isLocatedIn_place_CommentId on comment_isLocatedIn_place(CommentId);
-- create index comment_isLocatedIn_place_PlaceId on comment_isLocatedIn_place(PlaceId);
-- create index comment_replyOf_comment_CommentId on comment_replyOf_comment(CommentId);
-- create index comment_replyOf_comment_ParentCommentId on comment_replyOf_comment(ParentCommentId);
-- create index comment_replyOf_post_CommentId on comment_replyOf_post(CommentId);
-- create index comment_replyOf_post_ParentPostId on comment_replyOf_post(ParentPostId);
-- create index forum_containerOf_post_ForumId on forum_containerOf_post(ForumId);
-- create index forum_containerOf_post_PostId on forum_containerOf_post(PostId);
-- create index forum_hasMember_person_ForumId on forum_hasMember_person(ForumId);
-- create index forum_hasMember_person_PersonId on forum_hasMember_person(PersonId);
-- create index forum_hasModerator_person_ForumId on forum_hasModerator_person(ForumId);
-- create index forum_hasModerator_person_PersonId on forum_hasModerator_person(PersonId);
-- create index forum_hasTag_tag_ForumId on forum_hasTag_tag(ForumId);
-- create index forum_hasTag_tag_TagId on forum_hasTag_tag(TagId);
-- create index person_hasInterest_tag_PersonId on person_hasInterest_tag(PersonId);
-- create index person_hasInterest_tag_TagId on person_hasInterest_tag(TagId);
-- create index person_isLocatedIn_place_PersonId on person_isLocatedIn_place(PersonId);
-- create index person_isLocatedIn_place_PlaceId on person_isLocatedIn_place(PlaceId);
-- create index person_likes_comment_PersonId on person_likes_comment(PersonId);
-- create index person_likes_comment_CommentId on person_likes_comment(CommentId);
-- create index person_likes_post_PersonId on person_likes_post(PersonId);
-- create index person_likes_post_PostId on person_likes_post(PostId);
-- create index person_studyAt_organisation_PersonId on person_studyAt_organisation(PersonId);
-- create index person_studyAt_organisation_OrganisationId on person_studyAt_organisation(OrganisationId);
-- create index person_workAt_organisation_PersonId on person_workAt_organisation(PersonId);
-- create index person_workAt_organisation_OrganisationId on person_workAt_organisation(OrganisationId);
-- create index post_hasCreator_person_PostId on post_hasCreator_person(PostId);
-- create index post_hasCreator_person_PersonId on post_hasCreator_person(PersonId);
-- create index post_hasTag_tag_PostId on post_hasTag_tag(PostId);
-- create index post_hasTag_tag_TagId on post_hasTag_tag(TagId);
-- create index post_isLocatedIn_place_PostId on post_isLocatedIn_place(PostId);
-- create index post_isLocatedIn_place_PlaceId on post_isLocatedIn_place(PlaceId);
-- create index person_knows_person_Person1Id on person_knows_person(Person1Id);
-- create index person_knows_person_Person2Id on person_knows_person(Person2Id);

-- create index comment_replyOf_message_CommentId on comment_replyOf_message(CommentId);
-- create index comment_replyOf_message_ParentMessageId on comment_replyOf_message(ParentMessageId);
-- create index message_hasCreator_person_MessageId on message_hasCreator_person(MessageId);
-- create index message_hasCreator_person_PersonId on message_hasCreator_person(PersonId);
-- create index message_hasTag_tag_MessageId on message_hasTag_tag(MessageId);
-- create index message_hasTag_tag_TagId on message_hasTag_tag(TagId);
-- create index message_isLocatedIn_place_MessageId on message_isLocatedIn_place(MessageId);
-- create index message_isLocatedIn_place_PlaceId on message_isLocatedIn_place(PlaceId);
-- create index person_likes_message_PersonId on person_likes_message(PersonId);
-- create index person_likes_message_MessageId on person_likes_message(MessageId);
