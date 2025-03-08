import duckdb
import time
import sys
import signal
from contextlib import contextmanager
print(duckdb.__version__)

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

def load_property_graph(con):
    con.execute("""
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


                """)

def run_query(con, sf, query_id, query_spec, numThreads, results_file):
    print(query_spec)
    start = time.time()
    try:
        with timeout(300):
            con.execute(f"PRAGMA threads={numThreads};\n" + query_spec)
    except TimeoutError:
        return
    result = con.fetchall()
    end = time.time()
    duration = end - start
    results_file.write(f"DuckPGQ-{duckdb.__version__}\t{numThreads} threads\t{sf}\t{query_id}\t{duration:.4f}\t{result[0][0]}\n")
    results_file.flush()
    return (duration, result)

sf = None
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

if sf is None:
    quit(1)

con = duckdb.connect(database=f'scratch/lsqb-{sf}.duckdb')

con.install_extension("duckpgq", repository="community", force_install=True)
con.load_extension("duckpgq")

load_property_graph(con)

with open(f"../results/results.csv", "a+") as results_file:
    for i in range(1,10):
        print(i)
        with open(f"../pgq/q{i}.sql", "r") as query_file:
            run_query(con, sf, i, query_file.read(), numThreads, results_file)

con.close()
