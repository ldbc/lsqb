CREATE TABLE Company (
    CompanyId bigint NOT NULL,
    isLocatedIn_CountryId bigint NOT NULL
);
CREATE TABLE University (
    UniversityId bigint NOT NULL,
    isLocatedIn_CityId bigint NOT NULL
);
CREATE TABLE Continent (
    ContinentId bigint NOT NULL
);
CREATE TABLE Country (
    CountryId bigint NOT NULL,
    isPartOf_ContinentId bigint NOT NULL
);
CREATE TABLE City (
    CityId bigint NOT NULL,
    isPartOf_CountryId bigint NOT NULL
);
CREATE TABLE Tag (
    TagId bigint NOT NULL,
    hasType_TagClassId bigint NOT NULL
);
CREATE TABLE TagClass (
    TagClassId bigint NOT NULL,
    isSubclassOf_TagClassId bigint -- null for the root TagClass
);
CREATE TABLE Forum (
    ForumId bigint NOT NULL,
    hasModerator_PersonId bigint NOT NULL
);
CREATE TABLE Comment (
    CommentId bigint NOT NULL,
    hasCreator_PersonId bigint NOT NULL,
    isLocatedIn_CountryId bigint NOT NULL,
    replyOf_PostId bigint,
    replyOf_CommentId bigint -- either replyOf_PostId or replyOf_CommentId is NULL
);
CREATE TABLE Post (
    PostId bigint NOT NULL,
    hasCreator_PersonId bigint NOT NULL,
    Forum_containerOfId bigint NOT NULL,
    isLocatedIn_CountryId bigint NOT NULL
);
CREATE TABLE Person (
    PersonId bigint NOT NULL,
    isLocatedIn_CityId bigint NOT NULL
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
