import redis
from redisgraph import Node, Edge, Graph, Path

redis = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', redis)
query = """MATCH (p1:Person)-[:KNOWS]-(p2:Person)-[:KNOWS]-(p3:Person)-[:KNOWS]-(p1:Person) RETURN count(*) AS triangleCount"""
result = graph.query(query)
result.pretty_print()
