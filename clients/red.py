import redis
from redisgraph import Node, Edge, Graph, Path

r = redis.Redis(host='localhost', port=6379)

redis_graph = Graph('social', r)

john = Node(label='person', properties={'name': 'John Doe', 'age': 33, 'gender': 'male', 'status': 'single'})
redis_graph.add_node(john)

japan = Node(label='country', properties={'name': 'Japan'})
redis_graph.add_node(japan)

edge = Edge(john, 'visited', japan, properties={'purpose': 'pleasure'})
redis_graph.add_edge(edge)

redis_graph.commit()

query = """MATCH (p:person)-[v:visited {purpose:"pleasure"}]->(c:country)
		   RETURN p.name, p.age, v.purpose, c.name"""

result = redis_graph.query(query)

# Print resultset
result.pretty_print()

# Use parameters
params = {'purpose':"pleasure"}
query = """MATCH (p:person)-[v:visited {purpose:$purpose}]->(c:country)
		   RETURN p.name, p.age, v.purpose, c.name"""

result = redis_graph.query(query, params)

# Print resultset
result.pretty_print()

# Use query timeout to raise an exception if the query takes over 10 milliseconds
result = redis_graph.query(query, params, timeout=10)

# Iterate through resultset
for record in result.result_set:
	person_name = record[0]
	person_age = record[1]
	visit_purpose = record[2]
	country_name = record[3]
	
query = """MATCH p = (:person)-[:visited {purpose:"pleasure"}]->(:country) RETURN p"""

result = redis_graph.query(query)

# Iterate through resultset
for record in result.result_set:
    path = record[0]
    print(path)


# All done, remove graph.
redis_graph.delete()