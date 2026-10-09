"""Loads the LSQB data (merged-FK layout) into ArcadeDB with the /api/v1/batch endpoint."""
import csv
import http.client
import json
import os
import sys

from common import AUTH, DB, HOST, PORT, command, post

data_dir = os.environ["IMPORT_DATA_DIR_MERGED_FK"]

post("/api/v1/server", {"command": f"create database {DB}"})

# Post and Comment extend Message, so the :Message label matches both
for ddl in [
    "CREATE VERTEX TYPE Country", "CREATE VERTEX TYPE City", "CREATE VERTEX TYPE TagClass",
    "CREATE VERTEX TYPE Tag", "CREATE VERTEX TYPE Person", "CREATE VERTEX TYPE Forum",
    "CREATE VERTEX TYPE Message", "CREATE VERTEX TYPE Post EXTENDS Message",
    "CREATE VERTEX TYPE Comment EXTENDS Message", "CREATE VERTEX TYPE Continent",
    "CREATE VERTEX TYPE Company", "CREATE VERTEX TYPE University",
]:
    command(ddl)
for t in ["Continent", "Country", "City", "University", "Company", "TagClass", "Tag", "Person",
          "Forum", "Message"]:
    command(f"CREATE PROPERTY {t}.cid IF NOT EXISTS LONG")
    command(f"CREATE INDEX ON {t}(cid) UNIQUE")
for e in ["IS_PART_OF", "IS_LOCATED_IN", "HAS_MEMBER", "CONTAINER_OF", "REPLY_OF", "HAS_TAG",
          "HAS_TYPE", "HAS_CREATOR", "KNOWS", "LIKES", "HAS_INTEREST", "HAS_MODERATOR",
          "IS_SUBCLASS_OF", "STUDY_AT", "WORK_AT"]:
    command(f"CREATE EDGE TYPE {e}")

VERTICES = ["Continent", "Country", "City", "University", "Company", "TagClass", "Tag", "Person", "Forum", "Post", "Comment"]

# (edge type, csv file, source type, source column, target type, target column)
EDGES = [
    ("IS_PART_OF", "Country.csv", "Country", "id", "Continent", "ispartof_continent"),
    ("IS_PART_OF", "City.csv", "City", "id", "Country", "ispartof_country"),
    ("IS_SUBCLASS_OF", "TagClass.csv", "TagClass", "id", "TagClass", "issubclassof_tagclass"),
    ("IS_LOCATED_IN", "University.csv", "University", "id", "City", "islocatedin_city"),
    ("IS_LOCATED_IN", "Company.csv", "Company", "id", "Country", "islocatedin_country"),
    ("IS_LOCATED_IN", "Post.csv", "Post", "id", "Country", "islocatedin_country"),
    ("IS_LOCATED_IN", "Comment.csv", "Comment", "id", "Country", "islocatedin_country"),
    ("HAS_MODERATOR", "Forum.csv", "Forum", "id", "Person", "hasmoderator_person"),
    ("HAS_TAG", "Forum_hasTag_Tag.csv", "Forum", "id", "Tag", "hastag_tag"),
    ("STUDY_AT", "Person_studyAt_University.csv", "Person", "id", "University", "studyat_university"),
    ("WORK_AT", "Person_workAt_Company.csv", "Person", "id", "Company", "workat_company"),
    ("IS_LOCATED_IN", "Person.csv", "Person", "id", "City", "islocatedin_city"),
    ("HAS_TYPE", "Tag.csv", "Tag", "id", "TagClass", "hastype_tagclass"),
    ("HAS_CREATOR", "Post.csv", "Post", "id", "Person", "hascreator_person"),
    ("CONTAINER_OF", "Post.csv", "Forum", "forum_containerof", "Post", "id"),
    ("HAS_CREATOR", "Comment.csv", "Comment", "id", "Person", "hascreator_person"),
    ("REPLY_OF", "Comment.csv", "Comment", "id", "Post", "replyof_post"),
    ("REPLY_OF", "Comment.csv", "Comment", "id", "Comment", "replyof_comment"),
    ("HAS_MEMBER", "Forum_hasMember_Person.csv", "Forum", "id", "Person", "hasmember_person"),
    ("HAS_TAG", "Comment_hasTag_Tag.csv", "Comment", "id", "Tag", "hastag_tag"),
    ("HAS_TAG", "Post_hasTag_Tag.csv", "Post", "id", "Tag", "hastag_tag"),
    ("KNOWS", "Person_knows_Person.csv", "Person", "person1id", "Person", "person2id"),
    ("LIKES", "Person_likes_Comment.csv", "Person", "id", "Comment", "likes_comment"),
    ("LIKES", "Person_likes_Post.csv", "Person", "id", "Post", "likes_post"),
    ("HAS_INTEREST", "Person_hasInterest_Tag.csv", "Person", "id", "Tag", "hasinterest_tag"),
]


def rows(name):
    with open(os.path.join(data_dir, name), newline="") as f:
        yield from csv.DictReader(f, delimiter="|")


def jsonl():
    # All vertices first, then all edges. Edges refer to a vertex by its 0-based position in the
    # payload (refMode=ordinal): the server keeps 12 bytes per vertex instead of a map of ids.
    ordinal = {}  # (type, csv id) -> position
    for vtype in VERTICES:
        for row in rows(f"{vtype}.csv"):
            ordinal[vtype, row["id"]] = len(ordinal)
            yield (json.dumps({"@type": "vertex", "@class": vtype, "cid": int(row["id"])}) + "\n").encode()
    for etype, name, stype, scol, ttype, tcol in EDGES:
        for row in rows(name):
            src, dst = row.get(scol, ""), row.get(tcol, "")
            if src and dst:
                yield (json.dumps({"@type": "edge", "@class": etype, "@from": ordinal[stype, src],
                                   "@to": ordinal[ttype, dst]}) + "\n").encode()


conn = http.client.HTTPConnection(HOST, PORT, timeout=3000)
conn.request("POST", f"/api/v1/batch/{DB}?wal=false&lightEdges=false&refMode=ordinal", body=jsonl(),
             headers={"Authorization": AUTH, "Content-Type": "application/x-ndjson"},
             encode_chunked=True)
resp = conn.getresponse()
body = resp.read().decode()
if resp.status != 200:
    sys.exit(f"Batch load failed: HTTP {resp.status} {body[:500]}")
result = json.loads(body)
result.pop("idMapping", None)  # one entry per vertex, too large to print
print(result)
