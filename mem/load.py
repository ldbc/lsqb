import mgclient
import sys
from contextlib import contextmanager

con = mgclient.connect(host='127.0.0.1', port=27687)

nodes = [
    {"filename": "City",       "label": "City"           },
    {"filename": "Comment",    "label": "Comment:Message"},
    {"filename": "Company",    "label": "Company"        },
    {"filename": "Continent",  "label": "Continent"      },
    {"filename": "Country",    "label": "Country"        },
    {"filename": "Forum",      "label": "Forum"          },
    {"filename": "Person",     "label": "Person"         },
    {"filename": "Post",       "label": "Post:Message"   },
    {"filename": "TagClass",   "label": "TagClass"       },
    {"filename": "Tag",        "label": "Tag"            },
    {"filename": "University", "label": "University"     },
]
edges = [
    {"filename": "City_isPartOf_Country",          "source_label": "City",       "type": "IS_PART_OF",     "target_label": "Country"   },
    {"filename": "Comment_hasCreator_Person",      "source_label": "Comment",    "type": "HAS_CREATOR",    "target_label": "Person"    },
    {"filename": "Comment_hasTag_Tag",             "source_label": "Comment",    "type": "HAS_TAG",        "target_label": "Tag"       },
    {"filename": "Comment_isLocatedIn_Country",    "source_label": "Comment",    "type": "IS_LOCATED_IN",  "target_label": "Country"   },
    {"filename": "Comment_replyOf_Comment",        "source_label": "Comment",    "type": "REPLY_OF",       "target_label": "Comment"   },
    {"filename": "Comment_replyOf_Post",           "source_label": "Comment",    "type": "REPLY_OF",       "target_label": "Post"      },
    {"filename": "Company_isLocatedIn_Country",    "source_label": "Company",    "type": "IS_LOCATED_IN",  "target_label": "Country"   },
    {"filename": "Country_isPartOf_Continent",     "source_label": "Country",    "type": "IS_PART_OF",     "target_label": "Continent" },
    {"filename": "Forum_containerOf_Post",         "source_label": "Forum",      "type": "CONTAINER_OF",   "target_label": "Post"      },
    {"filename": "Forum_hasMember_Person",         "source_label": "Forum",      "type": "HAS_MEMBER",     "target_label": "Person"    },
    {"filename": "Forum_hasModerator_Person",      "source_label": "Forum",      "type": "HAS_MODERATOR",  "target_label": "Person"    },
    {"filename": "Forum_hasTag_Tag",               "source_label": "Forum",      "type": "HAS_TAG",        "target_label": "Tag"       },
    {"filename": "Person_hasInterest_Tag",         "source_label": "Person",     "type": "HAS_INTEREST",   "target_label": "Tag"       },
    {"filename": "Person_isLocatedIn_City",        "source_label": "Person",     "type": "IS_LOCATED_IN",  "target_label": "City"      },
    {"filename": "Person_knows_Person",            "source_label": "Person",     "type": "KNOWS",          "target_label": "Person"    },
    {"filename": "Person_likes_Comment",           "source_label": "Person",     "type": "LIKES",          "target_label": "Comment"   },
    {"filename": "Person_likes_Post",              "source_label": "Person",     "type": "LIKES",          "target_label": "Post"      },
    {"filename": "Person_studyAt_University",      "source_label": "Person",     "type": "STUDY_AT",       "target_label": "University"},
    {"filename": "Person_workAt_Company",          "source_label": "Person",     "type": "WORK_AT",        "target_label": "Company"   },
    {"filename": "Post_hasCreator_Person",         "source_label": "Post",       "type": "HAS_CREATOR",    "target_label": "Person"    },
    {"filename": "Post_hasTag_Tag",                "source_label": "Post",       "type": "HAS_TAG",        "target_label": "Tag"       },
    {"filename": "Post_isLocatedIn_Country",       "source_label": "Post",       "type": "IS_LOCATED_IN",  "target_label": "Country"   },
    {"filename": "TagClass_isSubclassOf_TagClass", "source_label": "TagClass",   "type": "IS_SUBCLASS_OF", "target_label": "TagClass"  },
    {"filename": "Tag_hasType_TagClass",           "source_label": "Tag",        "type": "HAS_TYPE",       "target_label": "TagClass"  },
    {"filename": "University_isLocatedIn_City",    "source_label": "University", "type": "IS_LOCATED_IN",  "target_label": "City"      },
]

con.autocommit = True
cur = con.cursor()

cur.execute("CREATE INDEX ON :Message(id)")
cur.execute("CREATE INDEX ON :Comment(id)")
cur.execute("CREATE INDEX ON :Post(id)")
cur.execute("CREATE INDEX ON :Person(id)")
cur.execute("CREATE INDEX ON :Forum(id)")

cur.execute("CREATE INDEX ON :Tag(id)")
cur.execute("CREATE INDEX ON :TagClass(id)")

cur.execute("CREATE INDEX ON :City(id)")
cur.execute("CREATE INDEX ON :Country(id)")
cur.execute("CREATE INDEX ON :Continent(id)")

cur.execute("CREATE INDEX ON :Company(id)")
cur.execute("CREATE INDEX ON :University(id)")

for node in nodes:
    filename = node["filename"]
    #print(filename)
    label = node["label"]
    load_node_query = f"""
        LOAD CSV FROM '/import/{filename}.csv-headerless'
            NO HEADER
            DELIMITER '|'
            AS row
        CREATE (:{label} {{ id: toInteger(row[0]) }})
        """
    cur.execute(load_node_query)
    cur.fetchall()

for edge in edges:
    filename = edge["filename"]
    #print(filename)
    source_label = edge["source_label"]
    type = edge["type"]
    target_label = edge["target_label"]

    load_edge_query = f"""
        LOAD CSV FROM '/import/{filename}.csv-headerless'
            NO HEADER
            DELIMITER '|'
            AS row
        MATCH
            (sourceNode:{source_label} {{ id: toInteger(row[0]) }}),
            (targetNode:{target_label} {{ id: toInteger(row[1]) }})
        CREATE (sourceNode)-[:{type}]->(targetNode)
        """
    cur.execute(load_edge_query)
    cur.fetchall()
