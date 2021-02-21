drop view if exists message;
drop view if exists Comment_replyOf_message;
drop view if exists message_hasCreator_Person;
drop view if exists message_hasTag_Tag;
drop view if exists message_isLocatedIn_Place;
drop view if exists Person_likes_message;

drop table if exists organisation;
drop table if exists place;
drop table if exists tag;
drop table if exists tagclass;

drop table if exists comment;
drop table if exists forum;
drop table if exists person;
drop table if exists post;

drop table if exists TagClass_isSubclassOf_TagClass;
drop table if exists Tag_hasType_TagClass;
drop table if exists Organisation_isLocatedIn_Place;
drop table if exists Place_isPartOf_Place;

drop table if exists Comment_hasCreator_Person;
drop table if exists Comment_hasTag_Tag;
drop table if exists Comment_isLocatedIn_Place;
drop table if exists Comment_replyOf_Comment;
drop table if exists Comment_replyOf_Post;
drop table if exists Forum_containerOf_Post;
drop table if exists Forum_hasMember_Person;
drop table if exists Forum_hasModerator_Person;
drop table if exists Forum_hasTag_Tag;
drop table if exists Person_hasInterest_Tag;
drop table if exists Person_isLocatedIn_Place;
drop table if exists Person_likes_Comment;
drop table if exists Person_likes_Post;
drop table if exists Person_studyAt_Organisation;
drop table if exists Person_workAt_Organisation;
drop table if exists Post_hasCreator_Person;
drop table if exists Post_hasTag_Tag;
drop table if exists Post_isLocatedIn_Place;
drop table if exists Person_knows_Person;