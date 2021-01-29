import duckdb

con = duckdb.connect(database='ddb-scratch/ldbc.duckdb', read_only=True)
con.execute("""
SELECT count(*)
FROM person_knows_person k1, person_knows_person k2, person_knows_person k3
WHERE k1.person2id = k2.person1id
  AND k2.person2id = k3.person1id
  AND k3.person2id = k1.person1id;
""")

print(con.fetchall())
