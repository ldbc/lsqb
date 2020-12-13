import redis
from redisgraph import Node, Edge, Graph, Path

redis = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', redis)
graph.delete()
