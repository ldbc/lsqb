DROP VIEW IF EXISTS Message;
DROP VIEW IF EXISTS Comment_replyOf_Message;
DROP VIEW IF EXISTS Message_hasCreator_Person;
DROP VIEW IF EXISTS Message_hasTag_Tag;
DROP VIEW IF EXISTS Message_isLocatedIn_Country;
DROP VIEW IF EXISTS Person_likes_Message;

DROP VIEW IF EXISTS Continent;
DROP VIEW IF EXISTS Company;
DROP VIEW IF EXISTS University;
DROP VIEW IF EXISTS Country;
DROP VIEW IF EXISTS City;
DROP VIEW IF EXISTS Tag;
DROP VIEW IF EXISTS TagClass;
DROP VIEW IF EXISTS Forum;
DROP VIEW IF EXISTS Comment;
DROP VIEW IF EXISTS Post;
DROP VIEW IF EXISTS Person;
DROP VIEW IF EXISTS Comment_hasTag_Tag;
DROP VIEW IF EXISTS Post_hasTag_Tag;
DROP VIEW IF EXISTS Forum_hasMember_Person;
DROP VIEW IF EXISTS Forum_hasTag_Tag;
DROP VIEW IF EXISTS Person_hasInterest_Tag;
DROP VIEW IF EXISTS Person_likes_Comment;
DROP VIEW IF EXISTS Person_likes_Post;
DROP VIEW IF EXISTS Person_studyAt_University;
DROP VIEW IF EXISTS Person_workAt_Company;
DROP VIEW IF EXISTS Person_knows_Person;

DROP SOURCE IF EXISTS csv_Continent;
DROP SOURCE IF EXISTS csv_Company;
DROP SOURCE IF EXISTS csv_University;
DROP SOURCE IF EXISTS csv_Country;
DROP SOURCE IF EXISTS csv_City;
DROP SOURCE IF EXISTS csv_Tag;
DROP SOURCE IF EXISTS csv_TagClass;
DROP SOURCE IF EXISTS csv_Forum;
DROP SOURCE IF EXISTS csv_Comment;
DROP SOURCE IF EXISTS csv_Post;
DROP SOURCE IF EXISTS csv_Person;
DROP SOURCE IF EXISTS csv_Comment_hasTag_Tag;
DROP SOURCE IF EXISTS csv_Post_hasTag_Tag;
DROP SOURCE IF EXISTS csv_Forum_hasMember_Person;
DROP SOURCE IF EXISTS csv_Forum_hasTag_Tag;
DROP SOURCE IF EXISTS csv_Person_hasInterest_Tag;
DROP SOURCE IF EXISTS csv_Person_likes_Comment;
DROP SOURCE IF EXISTS csv_Person_likes_Post;
DROP SOURCE IF EXISTS csv_Person_studyAt_University;
DROP SOURCE IF EXISTS csv_Person_workAt_Company;
DROP SOURCE IF EXISTS csv_Person_knows_Person;

CREATE SOURCE csv_Continent                 (id)                                                                        FROM FILE 'PATHVAR/Continent.csv'                 FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Company                   (id, isLocatedIn_Country)                                                   FROM FILE 'PATHVAR/Company.csv'                   FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_University                (id, isLocatedIn_City)                                                      FROM FILE 'PATHVAR/University.csv'                FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Country                   (id, isPartOf_Continent)                                                    FROM FILE 'PATHVAR/Country.csv'                   FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_City                      (id, isPartOf_Country)                                                      FROM FILE 'PATHVAR/City.csv'                      FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Tag                       (id, hasType_TagClass)                                                      FROM FILE 'PATHVAR/Tag.csv'                       FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_TagClass                  (id, isSubclassOf_TagClass)                                                 FROM FILE 'PATHVAR/TagClass.csv'                  FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Forum                     (id, hasModerator_Person)                                                   FROM FILE 'PATHVAR/Forum.csv'                     FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Comment                   (id, hasCreator_Person, isLocatedIn_Country, replyOf_Post, replyOf_Comment) FROM FILE 'PATHVAR/Comment.csv'                   FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Post                      (id, hasCreator_Person, Forum_containerOf, isLocatedIn_Country)             FROM FILE 'PATHVAR/Post.csv'                      FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person                    (id, isLocatedIn_City)                                                      FROM FILE 'PATHVAR/Person.csv'                    FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Comment_hasTag_Tag        (id, hasTag_Tag)                                                            FROM FILE 'PATHVAR/Comment_hasTag_Tag.csv'        FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Post_hasTag_Tag           (id, hasTag_Tag)                                                            FROM FILE 'PATHVAR/Post_hasTag_Tag.csv'           FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Forum_hasMember_Person    (id, hasMember_Person)                                                      FROM FILE 'PATHVAR/Forum_hasMember_Person.csv'    FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Forum_hasTag_Tag          (id, hasTag_Tag)                                                            FROM FILE 'PATHVAR/Forum_hasTag_Tag.csv'          FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person_hasInterest_Tag    (id, hasInterest_Tag)                                                       FROM FILE 'PATHVAR/Person_hasInterest_Tag.csv'    FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person_likes_Comment      (id, likes_Comment)                                                         FROM FILE 'PATHVAR/Person_likes_Comment.csv'      FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person_likes_Post         (id, likes_Post)                                                            FROM FILE 'PATHVAR/Person_likes_Post.csv'         FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person_studyAt_University (id, studyAt_University)                                                    FROM FILE 'PATHVAR/Person_studyAt_University.csv' FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person_workAt_Company     (id, workAt_Company)                                                        FROM FILE 'PATHVAR/Person_workAt_Company.csv'     FORMAT CSV WITH HEADER DELIMITED BY '|';
CREATE SOURCE csv_Person_knows_Person       (Person1id, Person2id)                                                      FROM FILE 'PATHVAR/Person_knows_Person.csv'       FORMAT CSV WITH HEADER DELIMITED BY '|';

CREATE MATERIALIZED VIEW Continent                 AS SELECT id::bigint                                                                                                        FROM csv_Continent;
CREATE MATERIALIZED VIEW Company                   AS SELECT id::bigint, isLocatedIn_Country::bigint                                                                           FROM csv_Company;
CREATE MATERIALIZED VIEW University                AS SELECT id::bigint, isLocatedIn_City::bigint                                                                              FROM csv_University;
CREATE MATERIALIZED VIEW Country                   AS SELECT id::bigint, isPartOf_Continent::bigint                                                                            FROM csv_Country;
CREATE MATERIALIZED VIEW City                      AS SELECT id::bigint, isPartOf_Country::bigint                                                                              FROM csv_City;
CREATE MATERIALIZED VIEW Tag                       AS SELECT id::bigint, hasType_TagClass::bigint                                                                              FROM csv_Tag;
CREATE MATERIALIZED VIEW TagClass                  AS SELECT id::bigint, CASE WHEN isSubclassOf_TagClass='' THEN NULL ELSE isSubclassOf_TagClass::bigint END                   FROM csv_TagClass;
CREATE MATERIALIZED VIEW Forum                     AS SELECT id::bigint, hasModerator_Person::bigint                                                                           FROM csv_Forum;
CREATE MATERIALIZED VIEW Comment                   AS SELECT
        id::bigint,
        hasCreator_Person::bigint,
        isLocatedIn_Country::bigint,
        CASE WHEN replyOf_Post='' THEN NULL ELSE replyOf_Post::bigint END AS replyOf_Post,
        CASE WHEN replyOf_Comment='' THEN NULL ELSE replyOf_Comment::bigint END AS replyOf_Comment FROM csv_Comment;
CREATE MATERIALIZED VIEW Post                      AS SELECT id::bigint, hasCreator_Person::bigint, Forum_containerOf::bigint, isLocatedIn_Country::bigint                     FROM csv_Post;
CREATE MATERIALIZED VIEW Person                    AS SELECT id::bigint, isLocatedIn_City::bigint                                                                              FROM csv_Person;
CREATE MATERIALIZED VIEW Comment_hasTag_Tag        AS SELECT id::bigint, hasTag_Tag::bigint                                                                                    FROM csv_Comment_hasTag_Tag;
CREATE MATERIALIZED VIEW Post_hasTag_Tag           AS SELECT id::bigint, hasTag_Tag::bigint                                                                                    FROM csv_Post_hasTag_Tag;
CREATE MATERIALIZED VIEW Forum_hasMember_Person    AS SELECT id::bigint, hasMember_Person::bigint                                                                              FROM csv_Forum_hasMember_Person;
CREATE MATERIALIZED VIEW Forum_hasTag_Tag          AS SELECT id::bigint, hasTag_Tag::bigint                                                                                    FROM csv_Forum_hasTag_Tag;
CREATE MATERIALIZED VIEW Person_hasInterest_Tag    AS SELECT id::bigint, hasInterest_Tag::bigint                                                                               FROM csv_Person_hasInterest_Tag;
CREATE MATERIALIZED VIEW Person_likes_Comment      AS SELECT id::bigint, likes_Comment::bigint                                                                                 FROM csv_Person_likes_Comment;
CREATE MATERIALIZED VIEW Person_likes_Post         AS SELECT id::bigint, likes_Post::bigint                                                                                    FROM csv_Person_likes_Post;
CREATE MATERIALIZED VIEW Person_studyAt_University AS SELECT id::bigint, studyAt_University::bigint                                                                            FROM csv_Person_studyAt_University;
CREATE MATERIALIZED VIEW Person_workAt_Company     AS SELECT id::bigint, workAt_Company::bigint                                                                                FROM csv_Person_workAt_Company;
CREATE MATERIALIZED VIEW Person_knows_Person       AS
    SELECT Person1id::bigint, Person2id::bigint FROM csv_Person_knows_Person
    UNION ALL
    SELECT Person2id::bigint, Person1id::bigint FROM csv_Person_knows_Person;

-- create a common table for the message nodes and edges starting from/ending in message nodes.
CREATE MATERIALIZED VIEW Message AS
  SELECT id FROM Comment
  UNION ALL
  SELECT id FROM Post;

CREATE MATERIALIZED VIEW Comment_replyOf_Message AS
  SELECT id AS CommentId, replyOf_Post AS ParentMessageId FROM Comment
  where replyOf_Post IS NOT NULL
  UNION ALL
  SELECT id AS CommentId, replyOf_Comment AS ParentMessageId FROM Comment
  where replyOf_Comment IS NOT NULL;

CREATE MATERIALIZED VIEW Message_hasCreator_Person AS
  SELECT id AS MessageId, hasCreator_Person FROM Comment
  UNION ALL
  SELECT id AS MessageId, hasCreator_Person FROM Post;

CREATE MATERIALIZED VIEW Message_hasTag_Tag AS
  SELECT id AS MessageId, hasTag_Tag FROM Comment_hasTag_Tag
  UNION ALL
  SELECT id AS MessageId, hasTag_Tag FROM Post_hasTag_Tag;

CREATE MATERIALIZED VIEW Message_isLocatedIn_Country AS
  SELECT id AS MessageId, isLocatedIn_Country FROM Comment
  UNION ALL
  SELECT id AS MessageId, isLocatedIn_Country FROM Post;

CREATE MATERIALIZED VIEW Person_likes_Message AS
  SELECT id AS PersonId, likes_Comment AS MessageId FROM Person_likes_Comment
  UNION ALL
  SELECT id AS PersonId, likes_Post AS MessageId FROM Person_likes_Post;
