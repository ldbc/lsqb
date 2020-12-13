import mgclient

conn = mgclient.connect(host='127.0.0.1', port=27687)
cursor = conn.cursor()
cursor.execute("""MATCH (p1:Person)-[:KNOWS]-(p2:Person)-[:KNOWS]-(p3:Person)-[:KNOWS]-(p1:Person) RETURN count(*) AS triangleCount""")
row = cursor.fetchone()
print(row[0])
