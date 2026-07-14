\copy Company(id) FROM 'PATHVAR/Company.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy University(id) FROM 'PATHVAR/University.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Continent(id) FROM 'PATHVAR/Continent.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Country(id) FROM 'PATHVAR/Country.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy City(id) FROM 'PATHVAR/City.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Forum(id) FROM 'PATHVAR/Forum.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Comment(id) FROM 'PATHVAR/Comment.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Post(id) FROM 'PATHVAR/Post.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person(id) FROM 'PATHVAR/Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Tag(id) FROM 'PATHVAR/Tag.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy TagClass(id) FROM 'PATHVAR/TagClass.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Comment_hasTag_Tag (CommentId, TagId) FROM 'PATHVAR/Comment_hasTag_Tag.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Post_hasTag_Tag (PostId, TagId) FROM 'PATHVAR/Post_hasTag_Tag.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Forum_hasMember_Person (ForumId, PersonId) FROM 'PATHVAR/Forum_hasMember_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_hasInterest_Tag (PersonId, TagId) FROM 'PATHVAR/Person_hasInterest_Tag.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_likes_Comment (PersonId, CommentId) FROM 'PATHVAR/Person_likes_Comment.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_likes_Post (PersonId, PostId) FROM 'PATHVAR/Person_likes_Post.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_knows_Person (Person1id, Person2id) FROM 'PATHVAR/Person_knows_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_knows_Person (Person2id, Person1id) FROM 'PATHVAR/Person_knows_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy City_isPartOf_Country (CityId, CountryId) FROM 'PATHVAR/City_isPartOf_Country.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Tag_hasType_TagClass (TagId, TagClassId) FROM 'PATHVAR/Tag_hasType_TagClass.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Post_hasCreator_Person (PostId, PersonId) FROM 'PATHVAR/Post_hasCreator_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Comment_replyOf_Message (CommentId, MessageId) FROM 'PATHVAR/Comment_replyOf_Comment.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Comment_replyOf_Message (CommentId, MessageId) FROM 'PATHVAR/Comment_replyOf_Post.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Comment_replyOf_Post (CommentId, PostId) FROM 'PATHVAR/Comment_replyOf_Post.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Comment_hasCreator_Person (CommentId, PersonId) FROM 'PATHVAR/Comment_hasCreator_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Message_hasCreator_Person (MessageId, PersonId) FROM 'PATHVAR/Comment_hasCreator_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Message_hasCreator_Person (MessageId, PersonId) FROM 'PATHVAR/Post_hasCreator_Person.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Message_hasTag_Tag (MessageId, TagId) FROM 'PATHVAR/Comment_hasTag_Tag.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Message_hasTag_Tag (MessageId, TagId) FROM 'PATHVAR/Post_hasTag_Tag.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_likes_Message (PersonId, MessageId) FROM 'PATHVAR/Person_likes_Comment.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_likes_Message (PersonId, MessageId) FROM 'PATHVAR/Person_likes_Post.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Person_isLocatedIn_City (PersonId, CityId) FROM 'PATHVAR/Person_isLocatedIn_City.csv' (DELIMITER '|', HEADER, FORMAT csv);
\copy Forum_containerOf_Post (ForumId, PostId) FROM 'PATHVAR/Forum_containerOf_Post.csv' (DELIMITER '|', HEADER, FORMAT csv);

INSERT INTO Message SELECT id FROM Comment UNION ALL SELECT id FROM Post;

CREATE
PROPERTY GRAPH lsqb
VERTEX TABLES (
    Forum LABEL forum PROPERTIES (id),
    Comment LABEL comment PROPERTIES (id),
    Post LABEL post PROPERTIES (id),
    Message LABEL message PROPERTIES (id),
    University LABEL university PROPERTIES (id),
    Company LABEL company PROPERTIES (id),
    Person LABEL person PROPERTIES (id),
    Continent LABEL continent PROPERTIES (id),
    Country LABEL country PROPERTIES (id),
    City LABEL city PROPERTIES (id),
    Tag LABEL tag PROPERTIES (id),
    TagClass LABEL tagClass PROPERTIES (id)
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
    Message_hasCreator_Person   SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Message_hasCreator,
    Message_hasTag_Tag      SOURCE KEY (MessageId) REFERENCES Message (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL Message_hasTag,
    Person_hasInterest_Tag  SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (TagId) REFERENCES Tag (id)
                            LABEL hasInterest,
    Person_isLocatedIn_City     SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (CityId) REFERENCES City (id)
                            LABEL Person_isLocatedIn,
    Person_knows_Person     SOURCE KEY (Person1Id) REFERENCES Person (id)
                            DESTINATION KEY (Person2Id) REFERENCES Person (id)
                            LABEL Knows,
    Person_likes_Message    SOURCE KEY (PersonId) REFERENCES Person (id)
                            DESTINATION KEY (MessageId) REFERENCES Message (id)
                            LABEL likes_Message,
    Post_hasCreator_Person  SOURCE KEY (PostId) REFERENCES Post (id)
                            DESTINATION KEY (PersonId) REFERENCES Person (id)
                            LABEL Post_hasCreator,
    Tag_hasType_TagClass    SOURCE KEY (TagId) REFERENCES Tag (id)
                            DESTINATION KEY (TagClassId) REFERENCES TagClass (id)
                            LABEL hasType
);