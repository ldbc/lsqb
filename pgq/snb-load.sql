CREATE OR REPLACE TABLE Company                        AS FROM read_csv('PATHVAR/Company.csv',    column_names = ['id']);
CREATE OR REPLACE TABLE University                     AS FROM read_csv('PATHVAR/University.csv', column_names = ['id']);
CREATE OR REPLACE TABLE Continent                      AS FROM read_csv('PATHVAR/Continent.csv',  column_names = ['id']);
CREATE OR REPLACE TABLE Country                        AS FROM read_csv('PATHVAR/Country.csv',    column_names = ['id']);
CREATE OR REPLACE TABLE City                           AS FROM read_csv('PATHVAR/City.csv',       column_names = ['id']);
CREATE OR REPLACE TABLE Forum                          AS FROM read_csv('PATHVAR/Forum.csv',      column_names = ['id']);
CREATE OR REPLACE TABLE Comment                        AS FROM read_csv('PATHVAR/Comment.csv',    column_names = ['id']);
CREATE OR REPLACE TABLE Post                           AS FROM read_csv('PATHVAR/Post.csv',       column_names = ['id']);
CREATE OR REPLACE TABLE Person                         AS FROM read_csv('PATHVAR/Person.csv',     column_names = ['id']);
CREATE OR REPLACE TABLE Tag                            AS FROM read_csv('PATHVAR/Tag.csv',        column_names = ['id']);
CREATE OR REPLACE TABLE TagClass                       AS FROM read_csv('PATHVAR/TagClass.csv',   column_names = ['id']);

CREATE OR REPLACE TABLE City_isPartOf_Country          AS FROM read_csv('PATHVAR/City_isPartOf_Country.csv',          column_names = ['CityId', 'CountryId']);
CREATE OR REPLACE TABLE Comment_hasCreator_Person      AS FROM read_csv('PATHVAR/Comment_hasCreator_Person.csv',      column_names = ['CommentId', 'PersonId']);
CREATE OR REPLACE TABLE Comment_hasTag_Tag             AS FROM read_csv('PATHVAR/Comment_hasTag_Tag.csv',             column_names = ['CommentId', 'TagId']);
CREATE OR REPLACE TABLE Comment_isLocatedIn_Country    AS FROM read_csv('PATHVAR/Comment_isLocatedIn_Country.csv',    column_names = ['CommentId', 'CountryId']);
CREATE OR REPLACE TABLE Comment_replyOf_Comment        AS FROM read_csv('PATHVAR/Comment_replyOf_Comment.csv',        column_names = ['Comment1Id', 'Comment2Id']);
CREATE OR REPLACE TABLE Comment_replyOf_Post           AS FROM read_csv('PATHVAR/Comment_replyOf_Post.csv',           column_names = ['CommentId', 'PostId']);
CREATE OR REPLACE TABLE Company_isLocatedIn_Country    AS FROM read_csv('PATHVAR/Company_isLocatedIn_Country.csv',    column_names = ['CompanyId', 'CountryId']);
CREATE OR REPLACE TABLE Country_isPartOf_Continent     AS FROM read_csv('PATHVAR/Country_isPartOf_Continent.csv',     column_names = ['CountryId', 'ContinentId']);
CREATE OR REPLACE TABLE Forum_containerOf_Post         AS FROM read_csv('PATHVAR/Forum_containerOf_Post.csv',         column_names = ['ForumId', 'PostId']);
CREATE OR REPLACE TABLE Forum_hasMember_Person         AS FROM read_csv('PATHVAR/Forum_hasMember_Person.csv',         column_names = ['ForumId', 'PersonId']);
CREATE OR REPLACE TABLE Forum_hasModerator_Person      AS FROM read_csv('PATHVAR/Forum_hasModerator_Person.csv',      column_names = ['ForumId', 'PersonId']);
CREATE OR REPLACE TABLE Forum_hasTag_Tag               AS FROM read_csv('PATHVAR/Forum_hasModerator_Person.csv',      column_names = ['ForumId', 'TagId']);
CREATE OR REPLACE TABLE Person_hasInterest_Tag         AS FROM read_csv('PATHVAR/Person_hasInterest_Tag.csv',         column_names = ['PersonId', 'TagId']);
CREATE OR REPLACE TABLE Person_isLocatedIn_City        AS FROM read_csv('PATHVAR/Person_isLocatedIn_City.csv',        column_names = ['PersonId', 'CityId']);
CREATE OR REPLACE TABLE Person_knows_Person            AS FROM read_csv('PATHVAR/Person_knows_Person.csv',            column_names = ['Person1Id', 'Person2Id']);
CREATE OR REPLACE TABLE Person_likes_Comment           AS FROM read_csv('PATHVAR/Person_likes_Comment.csv',           column_names = ['PersonId', 'CommentId']);
CREATE OR REPLACE TABLE Person_likes_Post              AS FROM read_csv('PATHVAR/Person_likes_Post.csv',              column_names = ['PersonId', 'PostId']);
CREATE OR REPLACE TABLE Person_studyAt_University      AS FROM read_csv('PATHVAR/Person_studyAt_University.csv',      column_names = ['PersonId', 'UniversityId']);
CREATE OR REPLACE TABLE Person_workAt_Company          AS FROM read_csv('PATHVAR/Person_workAt_Company.csv',          column_names = ['PersonId', 'CompanyId']);
CREATE OR REPLACE TABLE Post_hasCreator_Person         AS FROM read_csv('PATHVAR/Post_hasCreator_Person.csv',         column_names = ['PostId', 'PersonId']);
CREATE OR REPLACE TABLE Post_hasTag_Tag                AS FROM read_csv('PATHVAR/Post_hasTag_Tag.csv',                column_names = ['PostId', 'TagId']);
CREATE OR REPLACE TABLE Post_isLocatedIn_Country       AS FROM read_csv('PATHVAR/Post_isLocatedIn_Country.csv',       column_names = ['PostId', 'CountryId']);
CREATE OR REPLACE TABLE Tag_hasType_TagClass           AS FROM read_csv('PATHVAR/Tag_hasType_TagClass.csv',           column_names = ['TagId', 'TagClassId']);
CREATE OR REPLACE TABLE TagClass_isSubclassOf_TagClass AS FROM read_csv('PATHVAR/TagClass_isSubclassOf_TagClass.csv', column_names = ['TagClass1Id', 'TagClass2Id']);
CREATE OR REPLACE TABLE University_isLocatedIn_City    AS FROM read_csv('PATHVAR/University_isLocatedIn_City.csv',    column_names = ['UniversityId', 'CityId']);

CREATE OR REPLACE TABLE Message AS
  FROM Comment
  UNION ALL
  FROM Post;

CREATE OR REPLACE TABLE Comment_replyOf_Message AS
  SELECT Comment1Id AS CommentId, Comment2Id AS MessageId
  FROM Comment_replyOf_Comment
  UNION ALL
  FROM Comment_replyOf_Post;

CREATE OR REPLACE TABLE Message_hasCreator_Person AS
  SELECT CommentId AS MessageId, PersonId
  FROM Comment_hasCreator_Person
  UNION ALL
  FROM Post_hasCreator_Person;

CREATE OR REPLACE TABLE Message_hasTag_Tag AS
  SELECT CommentId AS MessageId, TagId
  FROM Comment_hasTag_Tag
  UNION ALL
  FROM Post_hasTag_Tag;
 
CREATE OR REPLACE TABLE Message_isLocatedIn_Country AS
  SELECT CommentId AS MessageId, CountryId
  FROM Comment_isLocatedIn_Country
  UNION ALL
  FROM Post_isLocatedIn_Country;

CREATE OR REPLACE TABLE Person_likes_Message AS
  SELECT PersonId, CommentId AS MessageId
  FROM Person_likes_Comment
  UNION ALL
  SELECT PersonId, PostId AS MessageId
  FROM Person_likes_Post;

CREATE OR REPLACE TABLE Message_replyOf_Message AS
  SELECT Comment1Id, Comment2Id
  FROM Comment_replyOf_Comment
  UNION ALL
  FROM Comment_replyOf_Post;

CREATE OR REPLACE PROPERTY GRAPH lsqb
VERTEX TABLES (
    Forum, Comment, Post, Message,
    University, Company,
    Person, Continent, Country, City,
    Tag, TagClass
    )
EDGE TABLES (
    City_isPartOf_Country SOURCE KEY (CityId) REFERENCES City (id)
                            DESTINATION KEY (CountryId) REFERENCES Country (id),
    Comment_hasCreator_Person   SOURCE KEY (CommentId) REFERENCES Comment (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Comment_hasCreator,
    Comment_hasTag_Tag      SOURCE KEY (CommentId) REFERENCES Comment (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Comment_hasTag,
    Comment_isLocatedIn_Country     SOURCE KEY (CommentId) REFERENCES Comment (id)
                            DESTINATION KEY (CountryId) REFERENCES Tag (id)
                            LABEL Comment_isLocatedIn,
    Comment_replyOf_Comment SOURCE KEY (Comment1Id) REFERENCES Comment (id)
                            DESTINATION KEY (Comment2Id) REFERENCES Comment (id)
                            LABEL replyOf_Comment,
    Comment_replyOf_Message SOURCE KEY (CommentId) REFERENCES Comment (id)
                            DESTINATION KEY (MessageId) REFERENCES Message (id)
                            LABEL replyOf_Message,
    Comment_replyOf_Post    SOURCE KEY (CommentId) REFERENCES Comment (id)
                            DESTINATION KEY (PostId) REFERENCES Post (id)
                            LABEL replyOf_Post,
    Forum_containerOf_Post  SOURCE KEY (ForumId) REFERENCES Forum (id)
                            DESTINATION KEY (PostId) REFERENCES Post (id)
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
    Message_hasCreator_Person   SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Message_hasCreator,
    Message_hasTag_Tag      SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Message_hasTag,
    Message_isLocatedIn_Country SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (CountryId) REFERENCES Country (id)
                            LABEL Message_isLocatedIn,
    Message_replyOf_Message SOURCE KEY (Comment1Id) REFERENCES Message (id)
                            DESTINATION KEY (Comment2Id) REFERENCES Message (id)
                            LABEL Message_replyOf,
    Person_hasInterest_Tag  SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL hasInterest,
    Person_isLocatedIn_City     SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CityId) REFERENCES City (id)
                            LABEL Person_isLocatedIn,
    Person_knows_person     SOURCE KEY (Person1Id) REFERENCES Person (id)
                            DESTINATION KEY (Person2Id) REFERENCES Person (id)
                            LABEL Knows,
    Person_likes_Comment    SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CommentId) REFERENCES Comment (id)
                            LABEL likes_Comment,
    Person_likes_Message    SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (MessageId) REFERENCES Message (id)
                            LABEL likes_Message,
    Person_likes_Post       SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (PostId) REFERENCES Post (id)
                            LABEL likes_Post,
    Person_studyAt_University   SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (UniversityId) REFERENCES University (id)
                            LABEL studyAt,
    Person_workAt_Company   SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CompanyId) REFERENCES Company (id)
                            LABEL workAt,
    Post_hasCreator_Person  SOURCE KEY (PostId) REFERENCES Post (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Post_hasCreator,
    Post_hasTag_Tag         SOURCE KEY (PostId) REFERENCES Post (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Post_hasTag,
    Post_isLocatedIn_Country    SOURCE KEY (PostId) REFERENCES Post (id)
                            DESTINATION KEY (CountryId) REFERENCES Country (id)
                            LABEL Post_isLocatedIn,
    Tag_hasType_TagClass    SOURCE KEY (TagId) REFERENCES Tag (id)
                            DESTINATION KEY (TagClassId) REFERENCES TagClass (id)
                            LABEL hasType,
    TagClass_isSubClassOf_TagClass  SOURCE KEY (TagClass1Id) REFERENCES TagClass (id)
                            DESTINATION KEY (TagClass2Id) REFERENCES TagClass (id)
                            LABEL isSubClassOf
    );
