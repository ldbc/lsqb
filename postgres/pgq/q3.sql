WITH pc AS (
    SELECT *
    FROM GRAPH_TABLE (lsqb
        MATCH (p IS Person)-[ilo IS Person_isLocatedIn]->(c IS City)-[ipo IS City_isPartOf_Country]->(country IS Country)
        COLUMNS (p.id AS pid, country.id AS cid)
     )
),
knows AS (
     SELECT *
     FROM GRAPH_TABLE (lsqb
        MATCH (p1 IS Person)-[k IS knows]-(p2 IS Person)
        COLUMNS (p1.id AS p1, p2.id AS p2)
    )
)

SELECT count(*) FROM pc pc1
JOIN pc pc2 ON pc1.cid = pc2.cid
JOIN pc pc3 ON pc1.cid = pc3.cid
JOIN knows k12 ON pc1.pid = k12.p1 AND pc2.pid = k12.p2
JOIN knows k23 ON pc2.pid = k23.p1 AND pc3.pid = k23.p2
JOIN knows k31 ON pc3.pid = k31.p1 AND pc1.pid = k31.p2;