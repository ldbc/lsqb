import redis
from redisgraph import Node, Edge, Graph, Path

redis = redis.Redis(host='localhost', port=6379)
graph = Graph('SocialGraph', redis)
try:
    graph.delete()
except redis.exceptions.ResponseError:
    print("RedisGraph instance is fresh.")
