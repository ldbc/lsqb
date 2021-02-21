create table company                       (id bigint not null);
create table university                    (id bigint not null);
create table continent                     (id bigint not null);
create table country                       (id bigint not null);
create table city                          (id bigint not null);
create table tag                           (id bigint not null);
create table tagclass                      (id bigint not null);

create table comment                       (id bigint not null);
create table forum                         (id bigint not null);
create table person                        (id bigint not null);
create table post                          (id bigint not null);

create table TagClass_isSubclassOf_TagClass(TagClass1Id bigint not null,     TagClass2Id bigint not null    );
create table Tag_hasType_TagClass          (TagId bigint not null,           TagClassId bigint not null     );
create table University_isLocatedIn_City   (UniversityId bigint not null,    CityId bigint not null         );
create table Company_isLocatedIn_Country   (CompanyId bigint not null,       CountryId bigint not null      );
create table Country_isPartOf_Continent    (CountryId bigint not null,       ContinentId bigint not null    );
create table City_isPartOf_Country         (CityId bigint not null,          CountryId bigint not null      );

create table Comment_hasCreator_Person     (CommentId bigint not null,       PersonId bigint not null       );
create table Comment_hasTag_Tag            (CommentId bigint not null,       TagId bigint not null          );
create table Comment_isLocatedIn_Place     (CommentId bigint not null,       PlaceId bigint not null        );
create table Comment_replyOf_Comment       (CommentId bigint not null,       ParentCommentId bigint not null);
create table Comment_replyOf_Post          (CommentId bigint not null,       ParentPostId bigint not null   );
create table Forum_containerOf_Post        (ForumId bigint not null,         PostId bigint not null         );
create table Forum_hasMember_Person        (ForumId bigint not null,         PersonId bigint not null       );
create table Forum_hasModerator_Person     (ForumId bigint not null,         PersonId bigint not null       );
create table Forum_hasTag_Tag              (ForumId bigint not null,         TagId bigint not null          );
create table Person_hasInterest_Tag        (PersonId bigint not null,        TagId bigint not null          );
create table Person_isLocatedIn_Place      (PersonId bigint not null,        PlaceId bigint not null        );
create table Person_likes_Comment          (PersonId bigint not null,        CommentId bigint not null      );
create table Person_likes_Post             (PersonId bigint not null,        PostId bigint not null         );
create table Person_studyAt_University     (PersonId bigint not null,        UniversityId bigint not null   );
create table Person_workAt_Company         (PersonId bigint not null,        CompanyId bigint not null      );
create table Post_hasCreator_Person        (PostId bigint not null,          PersonId bigint not null       );
create table Post_hasTag_Tag               (PostId bigint not null,          TagId bigint not null          );
create table Post_isLocatedIn_Place        (PostId bigint not null,          PlaceId bigint not null        );
create table Person_knows_Person           (Person1Id bigint not null,       Person2Id bigint not null      );
