drop view if exists message;
drop view if exists comment_replyOf_message;
drop view if exists message_hasCreator_person;
drop view if exists message_hasTag_tag;
drop view if exists message_isLocatedIn_place;
drop view if exists person_likes_message;

drop table if exists organisation;
drop table if exists place;
drop table if exists tag;
drop table if exists tagclass;

drop table if exists comment;
drop table if exists forum;
drop table if exists person;
drop table if exists post;

drop table if exists tagclass_isSubclassOf_tagclass;
drop table if exists tag_hasType_tagclass;
drop table if exists organisation_isLocatedIn_place;
drop table if exists place_isPartOf_place;

drop table if exists comment_hasCreator_person;
drop table if exists comment_hasTag_tag;
drop table if exists comment_isLocatedIn_place;
drop table if exists comment_replyOf_comment;
drop table if exists comment_replyOf_post;
drop table if exists forum_containerOf_post;
drop table if exists forum_hasMember_person;
drop table if exists forum_hasModerator_person;
drop table if exists forum_hasTag_tag;
drop table if exists person_hasInterest_tag;
drop table if exists person_isLocatedIn_place;
drop table if exists person_likes_comment;
drop table if exists person_likes_post;
drop table if exists person_studyAt_organisation;
drop table if exists person_workAt_organisation;
drop table if exists post_hasCreator_person;
drop table if exists post_hasTag_tag;
drop table if exists post_isLocatedIn_place;
drop table if exists person_knows_person;