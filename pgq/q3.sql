SELECT count(*)
FROM GRAPH_TABLE (lsqb
    MATCH (country:Country),
    (person1:Person)-[ilo1:Person_isLocatedIn]->(city1:City)-[ipo1:City_isPartOf_Country]->(country:Country),
    (person2:Person)-[ilo2:Person_isLocatedIn]->(city2:City)-[ipo2:City_isPartOf_Country]->(country:Country),
    (person3:Person)-[ilo3:Person_isLocatedIn]->(city3:City)-[ipo3:City_isPartOf_Country]->(country:Country),
    (person1:Person)-[k:knows]-(person2:Person)-[k2:knows]-(person3:Person)-[k3:knows]-(person1:Person)
);
