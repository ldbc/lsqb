import mgclient
import sys
from contextlib import contextmanager

con = mgclient.connect(host='127.0.0.1', port=27687)

nodes = ["City", "Comment", "Company", "Continent", "Country", "Forum", "Person", "Post", "TagClass", "Tag", "University"]
edges = [
    {"source_label": "City",       "type": "isPartOf",     "target_label": "Country"   },
    {"source_label": "Comment",    "type": "hasCreator",   "target_label": "Person"    },
    {"source_label": "Comment",    "type": "hasTag",       "target_label": "Tag"       },
    {"source_label": "Comment",    "type": "isLocatedIn",  "target_label": "Country"   },
    {"source_label": "Comment",    "type": "replyOf",      "target_label": "Comment"   },
    {"source_label": "Comment",    "type": "replyOf",      "target_label": "Post"      },
    {"source_label": "Company",    "type": "isLocatedIn",  "target_label": "Country"   },
    {"source_label": "Country",    "type": "isPartOf",     "target_label": "Continent" },
    {"source_label": "Forum",      "type": "containerOf",  "target_label": "Post"      },
    {"source_label": "Forum",      "type": "hasMember",    "target_label": "Person"    },
    {"source_label": "Forum",      "type": "hasModerator", "target_label": "Person"    },
    {"source_label": "Forum",      "type": "hasTag",       "target_label": "Tag"       },
    {"source_label": "Person",     "type": "hasInterest",  "target_label": "Tag"       },
    {"source_label": "Person",     "type": "isLocatedIn",  "target_label": "City"      },
    {"source_label": "Person",     "type": "knows",        "target_label": "Person"    },
    {"source_label": "Person",     "type": "likes",        "target_label": "Comment"   },
    {"source_label": "Person",     "type": "likes",        "target_label": "Post"      },
    {"source_label": "Person",     "type": "studyAt",      "target_label": "University"},
    {"source_label": "Person",     "type": "workAt",       "target_label": "Company"   },
    {"source_label": "Post",       "type": "hasCreator",   "target_label": "Person"    },
    {"source_label": "Post",       "type": "hasTag",       "target_label": "Tag"       },
    {"source_label": "Post",       "type": "isLocatedIn",  "target_label": "Country"   },
    {"source_label": "TagClass",   "type": "isSubclassOf", "target_label": "TagClass"  },
    {"source_label": "Tag",        "type": "hasType",      "target_label": "TagClass"  },
    {"source_label": "University", "type": "isLocatedIn",  "target_label": "City"      }
]

cur = con.cursor()

for node in nodes:
    print(node)
    load_node_query = f"""
        LOAD CSV FROM '/import/{node}.csv'
            NO HEADER
            DELIMITER '|'
            AS row
        CREATE (:{node} {{ id: toInteger(row[0]) }})
        """
    cur.execute(load_node_query)

source_label = "Post"
type = "hasTag"
target_label = "Tag"

for edge in edges:
    source_label = edge["source_label"]
    type = edge["type"]
    target_label = edge["target_label"]
    print(f"{source_label}_{type}_{target_label}")

    load_edge_query = f"""
        LOAD CSV FROM '/import/{source_label}_{type}_{target_label}.csv'
            NO HEADER
            DELIMITER '|'
            AS row
        MATCH
            (sourceNode:{source_label} {{ id: toInteger(row[0]) }}),
            (targetNode:{target_label} {{ id: toInteger(row[1]) }})
        CREATE (sourceNode)-[:{type}]->(targetNode)
        """
    cur.execute(load_edge_query)
