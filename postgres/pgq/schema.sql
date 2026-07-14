CREATE TABLE Company
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE University
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Continent
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Message
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Country
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE City
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Tag
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE TagClass
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Forum
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Comment
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Post
(
    id bigint PRIMARY KEY NOT NULL
);
CREATE TABLE Person
(
    id bigint PRIMARY KEY NOT NULL
);

CREATE TABLE Comment_hasTag_Tag
(
    CommentId bigint NOT NULL,
    TagId     bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Post_hasTag_Tag
(
    PostId bigint NOT NULL,
    TagId  bigint NOT NULL,
    id     BIGSERIAL PRIMARY KEY
);
CREATE TABLE Forum_hasMember_Person
(
    ForumId  bigint NOT NULL,
    PersonId bigint NOT NULL,
    id       BIGSERIAL PRIMARY KEY
);
CREATE TABLE Person_hasInterest_Tag
(
    PersonId bigint NOT NULL,
    TagId    bigint NOT NULL,
    id       BIGSERIAL PRIMARY KEY
);
CREATE TABLE Person_likes_Comment
(
    PersonId  bigint NOT NULL,
    CommentId bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Person_likes_Post
(
    PersonId bigint NOT NULL,
    PostId   bigint NOT NULL,
    id       BIGSERIAL PRIMARY KEY
);
CREATE TABLE Person_knows_Person
(
    Person1Id bigint NOT NULL,
    Person2Id bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Comment_replyOf_Message
(
    CommentId bigint NOT NULL,
    MessageId bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Comment_replyOf_Post
(
    CommentId bigint NOT NULL,
    PostId    bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Comment_hasCreator_Person
(
    CommentId bigint NOT NULL,
    PersonId  bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Message_hasCreator_Person
(
    MessageId bigint NOT NULL,
    PersonId  bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Message_hasTag_Tag
(
    MessageId bigint NOT NULL,
    TagId     bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Person_likes_Message
(
    PersonId  bigint NOT NULL,
    MessageId bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE City_isPartOf_Country
(
    CityId    bigint NOT NULL,
    CountryId bigint NOT NULL,
    id        BIGSERIAL PRIMARY KEY
);
CREATE TABLE Tag_hasType_TagClass
(
    TagId      bigint NOT NULL,
    TagClassId bigint NOT NULL,
    id         BIGSERIAL PRIMARY KEY
);
CREATE TABLE Post_hasCreator_Person
(
    PostId   bigint NOT NULL,
    PersonId bigint NOT NULL,
    id       BIGSERIAL PRIMARY KEY
);
CREATE TABLE Person_isLocatedIn_City
(
    PersonId bigint NOT NULL,
    CityId   bigint NOT NULL,
    id       BIGSERIAL PRIMARY KEY
);
CREATE TABLE Forum_containerOf_Post
(
    ForumId bigint NOT NULL,
    PostId  bigint NOT NULL,
    id      BIGSERIAL PRIMARY KEY
);