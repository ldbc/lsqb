# Neo4j for reachability testing

* Place the CSV files under `data/` in the repository root, e.g. `data/social-network-sf0.1-projected-fk/`

* Run:

    ```bash
    export SF=0.1
    ./init-and-load.sh
    ```

* Open the browser: <http://localhost:7474/browser/>, click `Connect`

* Create graph:

    ```
    CALL gds.graph.create.cypher(
        'knows',
        'MATCH (p:Person) RETURN id(p) AS id',
        'MATCH (personA:Person)-[:KNOWS]-(personB:Person) RETURN id(personA) AS source, id(personB) AS target'
    )
    ```

* Run:

    ```
    MATCH (person1:Person), (person2:Person)
    WITH person1, person2
    ORDER BY person1.id ASC, person2.id ASC
    LIMIT 10
    CALL gds.shortestPath.dijkstra.stream('knows', { sourceNode: person1, targetNode: person2 })
    YIELD totalCost
    RETURN person1.id, person2.id, toInteger(totalCost) AS hops
    ORDER BY hops DESC, person1.id ASC, person2.id ASC
    LIMIT 20
    ```