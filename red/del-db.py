import redis
from redisgraph import Node, Edge, Graph, Path

r = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', r)
try:
    graph.delete()
except redis.exceptions.ResponseError as e:
    pass
