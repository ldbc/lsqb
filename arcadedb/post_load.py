"""Builds the Graph Analytical View (CSR) over all vertex and edge types."""
from common import command

if not command("SELECT name FROM schema:graphAnalyticalViews WHERE name = 'lsqb'")["result"]:
    command("CREATE GRAPH ANALYTICAL VIEW lsqb "
            "VERTEX TYPES (Continent, Country, City, University, Company, TagClass, Tag, Person, Forum, "
            "Post, Comment) "
            "EDGE TYPES (IS_PART_OF, IS_LOCATED_IN, HAS_MEMBER, CONTAINER_OF, REPLY_OF, HAS_TAG, "
            "HAS_TYPE, HAS_CREATOR, KNOWS, LIKES, HAS_INTEREST, HAS_MODERATOR, IS_SUBCLASS_OF, STUDY_AT, "
            "WORK_AT)")
# synchronous: returns once the CSR is built and registered with the query optimizer
command("REBUILD GRAPH ANALYTICAL VIEW lsqb")
print("Graph Analytical View ready")
