import duckdb
import time
import sys
import signal
from contextlib import contextmanager

@contextmanager
def timeout(t):
    signal.signal(signal.SIGALRM, raise_timeout)
    signal.alarm(t)

    try:
        yield
    except TimeoutError:
        raise
    finally:
        signal.signal(signal.SIGALRM, signal.SIG_IGN)

def raise_timeout(signum, frame):
    raise TimeoutError

def run_query(con, sf, query_id, query_spec, numThreads, results_file):
    start = time.time()
    try:
        with timeout(300):
            con.execute(f"PRAGMA threads={numThreads};\n" + query_spec)
    except TimeoutError:
        return
    result = con.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"DuckDB\t{numThreads} threads\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

if len(sys.argv) < 2:
    print("Usage: client.py sf [threads]")
    print("where sf is the scale factor")
    exit(1)
else:
    sf = sys.argv[1]

if len(sys.argv) > 2:
    numThreads = int(sys.argv[2])
else:
    numThreads = 4


print(f"Running DuckDB version {duckdb.__version__}")
con = duckdb.connect(database='ddb/scratch/ldbc.duckdb')

con.execute(f"""
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

-- create a common table for the message nodes and edges starting from/ending in message nodes.
CREATE VIEW Message AS
  SELECT CommentId AS MessageId FROM Comment
  UNION ALL
  SELECT PostId AS MessageId FROM Post;

CREATE VIEW Comment_replyOf_Message AS
  SELECT CommentId, replyOf_PostId AS ParentMessageId FROM Comment
  WHERE replyOf_PostId IS NOT NULL
  UNION ALL
  SELECT CommentId, replyOf_CommentId AS ParentMessageId FROM Comment
  WHERE replyOf_CommentId IS NOT NULL;

CREATE VIEW Message_hasCreator_Person AS
  SELECT CommentId AS MessageId, hasCreator_PersonId FROM Comment
  UNION ALL
  SELECT PostId AS MessageId, hasCreator_PersonId FROM Post;

CREATE VIEW Message_hasTag_Tag AS
  SELECT CommentId AS MessageId, TagId FROM Comment_hasTag_Tag
  UNION ALL
  SELECT PostId AS MessageId, TagId FROM Post_hasTag_Tag;
 
CREATE VIEW Message_isLocatedIn_Country AS
  SELECT CommentId AS MessageId, isLocatedIn_CountryId FROM Comment
  UNION ALL
  SELECT PostId AS MessageId, isLocatedIn_CountryId FROM Post;

CREATE VIEW Person_likes_Message AS
  SELECT PersonId, CommentId AS MessageId FROM Person_likes_Comment
  UNION ALL
  SELECT PersonId, PostId AS MessageId FROM Person_likes_Post;


    COPY Company                   FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Company.csv'                   (DELIMITER '|', HEADER, FORMAT csv);
    COPY University                FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/University.csv'                (DELIMITER '|', HEADER, FORMAT csv);
    COPY Continent                 FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Continent.csv'                 (DELIMITER '|', HEADER, FORMAT csv);
    COPY Country                   FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Country.csv'                   (DELIMITER '|', HEADER, FORMAT csv);
    COPY City                      FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/City.csv'                      (DELIMITER '|', HEADER, FORMAT csv);
    COPY Forum                     FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Forum.csv'                     (DELIMITER '|', HEADER, FORMAT csv);
    COPY Comment                   FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Comment.csv'                   (DELIMITER '|', HEADER, FORMAT csv);
    COPY Post                      FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Post.csv'                      (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person                    FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person.csv'                    (DELIMITER '|', HEADER, FORMAT csv);
    COPY Tag                       FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Tag.csv'                       (DELIMITER '|', HEADER, FORMAT csv);
    COPY TagClass                  FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/TagClass.csv'                  (DELIMITER '|', HEADER, FORMAT csv);
    COPY Comment_hasTag_Tag        FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Comment_hasTag_Tag.csv'        (DELIMITER '|', HEADER, FORMAT csv);
    COPY Post_hasTag_Tag           FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Post_hasTag_Tag.csv'           (DELIMITER '|', HEADER, FORMAT csv);
    COPY Forum_hasMember_Person    FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Forum_hasMember_Person.csv'    (DELIMITER '|', HEADER, FORMAT csv);
    COPY Forum_hasTag_Tag          FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Forum_hasTag_Tag.csv'          (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_hasInterest_Tag    FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_hasInterest_Tag.csv'    (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_likes_Comment      FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_likes_Comment.csv'      (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_likes_Post         FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_likes_Post.csv'         (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_studyAt_University FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_studyAt_University.csv' (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_workAt_Company     FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_workAt_Company.csv'     (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_knows_Person (Person1id, Person2id) FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_knows_Person.csv'       (DELIMITER '|', HEADER, FORMAT csv);
    COPY Person_knows_Person (Person2id, Person1id) FROM '/Users/szarnyasg/git/ldbc/lsqb/data/social-network-sf{sf}-merged-fk/Person_knows_Person.csv'       (DELIMITER '|', HEADER, FORMAT csv);
    """)

with open(f"results/results.csv", "a+") as results_file:
    for i in range(1, 10):
        print(i)
        with open(f"sql/q{i}.sql", "r") as query_file:
            run_query(con, sf, i, query_file.read(), numThreads, results_file)

con.close()
