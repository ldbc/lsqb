create table organisation                  (id bigint not null, label varchar);
create table place                         (id bigint not null, label varchar);
create table tag                           (id bigint not null);
create table tagclass                      (id bigint not null);

create table comment                       (id bigint not null);
create table forum                         (id bigint not null);
create table person                        (id bigint not null);
create table post                          (id bigint not null);

create table tagclass_isSubclassOf_tagclass(TagClass1Id bigint not null,     TagClass2Id bigint not null    );
create table tag_hasType_tagclass          (TagId bigint not null,           TagClassId bigint not null     );
create table organisation_isLocatedIn_place(OrganisationId bigint not null,  PlaceId bigint not null        );
create table place_isPartOf_place          (Place1Id bigint not null,        Place2Id bigint not null       );

create table comment_hasCreator_person     (CommentId bigint not null,       PersonId bigint not null       );
create table comment_hasTag_tag            (CommentId bigint not null,       TagId bigint not null          );
create table comment_isLocatedIn_place     (CommentId bigint not null,       PlaceId bigint not null        );
create table comment_replyOf_comment       (CommentId bigint not null,       ParentCommentId bigint not null);
create table comment_replyOf_post          (CommentId bigint not null,       ParentPostId bigint not null   );
create table forum_containerOf_post        (ForumId bigint not null,         PostId bigint not null         );
create table forum_hasMember_person        (ForumId bigint not null,         PersonId bigint not null       );
create table forum_hasModerator_person     (ForumId bigint not null,         PersonId bigint not null       );
create table forum_hasTag_tag              (ForumId bigint not null,         TagId bigint not null          );
create table person_hasInterest_tag        (PersonId bigint not null,        TagId bigint not null          );
create table person_isLocatedIn_place      (PersonId bigint not null,        PlaceId bigint not null        );
create table person_likes_comment          (PersonId bigint not null,        CommentId bigint not null      );
create table person_likes_post             (PersonId bigint not null,        PostId bigint not null         );
create table person_studyAt_organisation   (PersonId bigint not null,        OrganisationId bigint not null );
create table person_workAt_organisation    (PersonId bigint not null,        OrganisationId bigint not null );
create table post_hasCreator_person        (PostId bigint not null,          PersonId bigint not null       );
create table post_hasTag_tag               (PostId bigint not null,          TagId bigint not null          );
create table post_isLocatedIn_place        (PostId bigint not null,          PlaceId bigint not null        );
create table person_knows_person           (Person1Id bigint not null,       Person2Id bigint not null      );

create view message as
  select * from comment
  union all
  select * from post;

create view comment_replyOf_message as
  select CommentId, ParentCommentId as ParentMessageId from comment_replyOf_comment
  union all
  select CommentId, ParentPostId as ParentMessageId from comment_replyOf_post;
