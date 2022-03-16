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

## Testing

Take a sample:

```
match (p:Person)
with p
limit 10
return collect(p.id)
```

Example query for 10 × 10 source-target pairs on SF0.1:

```
UNWIND [17592186045004,8796093023616,772,35184372089012,28587302322668,26388279067664,28587302322904,2199023256472,2199023257100,13194139534592]
  AS source
UNWIND [28587302323188,28587302323208,17592186045248,19791209301288,28587302322876,6597069767744,2199023257212,6597069768352,15393162790380,10995116277916]
  AS target
MATCH (sourcePerson:Person {id: source}), (targetPerson {id: target})
CALL gds.shortestPath.dijkstra.stream('knows', { sourceNode: id(sourcePerson), targetNode: id(targetPerson) })
YIELD totalCost
RETURN source, target, toInteger(totalCost) AS hops
ORDER BY source, target
```

Data sets are at `/bigstore/gabor/surf-actual-data-set/actual/lsqb/lsqb-projected/`.
