CREATE TABLE Company (
    CompanyId bigint NOT NULL
);
CREATE TABLE University (
    UniversityId bigint NOT NULL
);
CREATE TABLE Continent (
    ContinentId bigint NOT NULL
);
CREATE TABLE Country (
    CountryId bigint NOT NULL
);
CREATE TABLE City (
    CityId bigint NOT NULL
);
CREATE TABLE Tag (
    TagId bigint NOT NULL
);
CREATE TABLE TagClass (
    TagClassId bigint NOT NULL
);
CREATE TABLE Forum (
    ForumId bigint NOT NULL
);
CREATE TABLE Comment (
    CommentId bigint NOT NULL
);
CREATE TABLE Post (
    PostId bigint NOT NULL
);
CREATE TABLE Person (
    PersonId bigint NOT NULL
);

CREATE TABLE Comment_hasTag_Tag       (CommentId bigint NOT NULL, TagId        bigint NOT NULL);
CREATE TABLE Post_hasTag_Tag          (PostId    bigint NOT NULL, TagId        bigint NOT NULL);
CREATE TABLE Forum_hasMember_Person   (ForumId   bigint NOT NULL, PersonId     bigint NOT NULL);
CREATE TABLE Forum_hasTag_Tag         (ForumId   bigint NOT NULL, TagId        bigint NOT NULL);
CREATE TABLE Person_hasInterest_Tag   (PersonId  bigint NOT NULL, TagId        bigint NOT NULL);
CREATE TABLE Person_likes_Comment     (PersonId  bigint NOT NULL, CommentId    bigint NOT NULL);
CREATE TABLE Person_likes_Post        (PersonId  bigint NOT NULL, PostId       bigint NOT NULL);
CREATE TABLE Person_studyAt_University(PersonId  bigint NOT NULL, UniversityId bigint NOT NULL);
CREATE TABLE Person_workAt_Company    (PersonId  bigint NOT NULL, CompanyId    bigint NOT NULL);
CREATE TABLE Person_knows_Person      (Person1Id bigint NOT NULL, Person2Id    bigint NOT NULL);



CREATE TABLE Message AS
  SELECT CommentId AS MessageId FROM Comment
  UNION ALL
  SELECT PostId AS MessageId FROM Post;

CREATE TABLE Comment_replyOf_Message AS
  SELECT CommentId, replyOf_PostId AS ParentMessageId FROM Comment
  WHERE replyOf_PostId IS NOT NULL
  UNION ALL
  SELECT CommentId, replyOf_CommentId AS ParentMessageId FROM Comment
  WHERE replyOf_CommentId IS NOT NULL;

CREATE TABLE Message_hasCreator_Person AS
  SELECT CommentId AS MessageId, hasCreator_PersonId FROM Comment
  UNION ALL
  SELECT PostId AS MessageId, hasCreator_PersonId FROM Post;

CREATE TABLE Message_hasTag_Tag AS
  SELECT CommentId AS MessageId, TagId FROM Comment_hasTag_Tag
  UNION ALL
  SELECT PostId AS MessageId, TagId FROM Post_hasTag_Tag;

CREATE TABLE Message_isLocatedIn_Country AS
  SELECT CommentId AS MessageId, isLocatedIn_CountryId FROM Comment
  UNION ALL
  SELECT PostId AS MessageId, isLocatedIn_CountryId FROM Post;

CREATE TABLE Person_likes_Message AS
  SELECT PersonId, CommentId AS MessageId FROM Person_likes_Comment
  UNION ALL
  SELECT PersonId, PostId AS MessageId FROM Person_likes_Post;

UPDATE Organisation set
    subcategory=case
    when type='University' then 2**0
    when type='Company' then 2**1
end;

ALTER TABLE comment ADD COLUMN type VARCHAR DEFAULT 'Comment';
ALTER TABLE post ADD COLUMN type VARCHAR DEFAULT 'Post';

CREATE OR REPLACE TABLE Message AS (SELECT * FROM Comment) UNION BY NAME (SELECT * FROM Post);

ALTER TABLE Message ADD COLUMN subcategory BIGINT;
UPDATE Message set
    subcategory=case
       when type='Comment' then 2**0
       when type='Post' then 2**1
    end;

ALTER TABLE Place ADD COLUMN subcategory BIGINT;
UPDATE Place set
    subcategory=case
       when type='Continent' then 2**0
       when type='Country' then 2**1
       when type='City' then 2**2
    end;


CREATE PROPERTY GRAPH lsqb
VERTEX TABLES (
    Forum, Message IN Subcategory(Comment, Post),
    Organisation IN Subcategory(University, Company),
    Person, Place IN Subcategory(Continent, Country, City),
    Tag, TagClass
    )
EDGE TABLES (
    Comment_hasCreator_Person   SOURCE KEY (CommentId) REFERENCES Message (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Comment_hasCreator,
    Comment_hasTag_Tag      SOURCE KEY (CommentId) REFERENCES Message (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Comment_hasTag,
    Comment_isLocatedIn_Country     SOURCE KEY (CommentId) REFERENCES Message (id)
                            DESTINATION KEY (CountryId) REFERENCES Tag (id)
                            LABEL Comment_isLocatedIn,
    Comment_replyOf_Comment SOURCE KEY (Comment1Id) REFERENCES Message (id)
                            DESTINATION KEY (Comment2Id) REFERENCES Message (id)
                            LABEL replyOf_Comment,
    Comment_replyOf_Post    SOURCE KEY (CommentId) REFERENCES Message (id)
                            DESTINATION KEY (PostId) REFERENCES Message (id)
                            LABEL replyOf_Post,
    Forum_containerOf_Post  SOURCE KEY (ForumId) REFERENCES Forum (id)
                            DESTINATION KEY (PostId) REFERENCES Message (id)
                            LABEL containerOf,
    Forum_hasMember_Person  SOURCE KEY (ForumId) REFERENCES Forum (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL hasMember,
    Forum_hasModerator_Person   SOURCE KEY (ForumId) REFERENCES Forum (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL hasModerator,
    Forum_hasTag_Tag        SOURCE KEY (ForumId) REFERENCES Forum (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Forum_hasTag,
    Organisation_isLocatedIn_Place  SOURCE KEY (OrganisationId) REFERENCES Organisation (id)
                            DESTINATION KEY (PlaceId) REFERENCES Place (id)
                            LABEL Organisation_isLocatedIn,
    Person_hasInterest_Tag  SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (interestId) REFERENCES Tag (id)
                            LABEL hasInterest,
    Person_isLocatedIn_City     SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CityId) REFERENCES Place (id)
                            LABEL Person_isLocatedIn,
    Person_knows_person     SOURCE KEY (Person1Id) REFERENCES Person (id)
                            DESTINATION KEY (Person2Id) REFERENCES Person (id)
                            LABEL Knows,
    Person_likes_Comment    SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CommentId) REFERENCES Message (id)
                            LABEL likes_Comment,
    Person_likes_Post       SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (PostId) REFERENCES Message (id)
                            LABEL likes_Post,
    Person_studyAt_University   SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (UniversityId) REFERENCES Organisation (id)
                            LABEL studyAt,
    Person_workAt_Company   SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CompanyId) REFERENCES Organisation (id)
                            LABEL workAt,
    Place_isPartOf_Place    SOURCE KEY (Place1Id) REFERENCES Place (id)
                            DESTINATION KEY (Place2Id) REFERENCES Place (id)
                            LABEL isPartOf,
    Post_hasCreator_Person  SOURCE KEY (PostId) REFERENCES Message (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Post_hasCreator,
    Message_hasCreator_Person   SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Message_hasCreator,
    Message_hasTag_Tag      SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Message_hasTag,
    Message_isLocatedIn_Country SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (CountryId) REFERENCES Place (id)
                            LABEL Message_isLocatedIn,
    Message_replyOf_Message SOURCE KEY (Comment1Id) REFERENCES Message (id)
                            DESTINATION KEY (Comment2Id) REFERENCES Message (id)
                            LABEL Message_replyOf,
    Post_hasTag_Tag         SOURCE KEY (PostId) REFERENCES Message (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Post_hasTag,
    Post_isLocatedIn_Country    SOURCE KEY (PostId) REFERENCES Message (id)
                            DESTINATION KEY (CountryId) REFERENCES Place (id)
                            LABEL Post_isLocatedIn,
    Tag_hasType_TagClass    SOURCE KEY (TagId) REFERENCES Tag (id)
                            DESTINATION KEY (TagClassId) REFERENCES TagClass (id)
                            LABEL hasType,
    TagClass_isSubClassOf_TagClass  SOURCE KEY (TagClass1Id) REFERENCES TagClass (id)
                            DESTINATION KEY (TagClass2Id) REFERENCES TagClass (id)
                            LABEL isSubClassOf
    );