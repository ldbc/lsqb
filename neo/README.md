# Neo4j for reachability testing

## Data set sizes

| sf      | Person    | knows       |
| ------: | --------: | ----------: |
| example |         5 |           6 |
| 0.003   |        50 |          88 |
| 0.1     |     1,700 |      18,135 |
| 0.3     |     3,900 |      57,095 |
| 1       |    11,000 |     226,293 |
| 3       |    27,000 |     698,627 |
| 10      |    73,000 |   2,380,850 |
| 30      |   184,000 |   7,273,036 |
| 100     |   499,000 |  23,841,591 |
| 300     | 1,254,000 |  70,144,162 |
| 1000    | 3,600,000 | 233,283,101 |

## Loading

* Place the CSV files under the `data/` directory, e.g. `data/social-network-sf0.1-projected-fk/`

* To load and start the database, run:

    ```bash
    export SF=0.1
    ./init-and-load.sh
    ```

## Sampling

* Open the browser: <http://localhost:7474/browser/>, click `Connect`

* Take two samples:

  ```
  MATCH (p:Person) WITH p
  ORDER BY apoc.util.md5([p.id]) ASC
  LIMIT 100
  RETURN collect(p.id)
  ```

  ```
  MATCH (p:Person) WITH p
  ORDER BY apoc.util.md5([p.id]) DESC
  LIMIT 100
  RETURN collect(p.id)
  ```

## Example query

Example query for n × n source-target pairs on SF0.1.

To run it with 100 × 100 pairs, run:

```bash
time docker exec lsqb-neo cypher-shell "`cat reach-gds.cypher`"
time docker exec lsqb-neo cypher-shell "`cat reach-shortestpath.cypher`"
```

### Vanilla Cypher approach

Using the `shortestPath` construct.

* Run MSBFS:

    ```
    UNWIND [...]
      AS source
    UNWIND [...]
      AS target
    MATCH (sourcePerson:Person {id: source}), (targetPerson:Person {id: target})
    OPTIONAL MATCH p=shortestPath((sourcePerson)-[:KNOWS*]-(targetPerson))
    WITH source, target, length(p) AS length
    ORDER BY source, target
    RETURN source, target, length
    ```

### GDS approach (create graph)

#### Unweighted variant

```
CALL gds.graph.create.cypher(
    'knows',
    'MATCH (p:Person) RETURN id(p) AS id',
    'OPTIONAL MATCH (personA:Person)-[:KNOWS]-(personB:Person) RETURN id(personA) AS source, id(personB) AS target'
)
```

Run query:

```
UNWIND [...]
  AS source
UNWIND [...]
  AS target
MATCH (sourcePerson:Person {id: source}), (targetPerson:Person {id: target})
CALL gds.shortestPath.dijkstra.stream('knows', { sourceNode: id(sourcePerson), targetNode: id(targetPerson) })
YIELD totalCost
WITH source, target, toInteger(totalCost) AS length
ORDER BY source, target
RETURN source, target, length
```

#### Weighted variant

```
CALL gds.graph.create(
    'knows',
    ['Person'],
    { KNOWS: { properties: 'weight' } }
)
```

```
UNWIND [...] AS source
UNWIND [...] AS target
MATCH (sourcePerson:Person {id: source}), (targetPerson:Person {id: target})
CALL gds.shortestPath.dijkstra.stream('knows', { sourceNode: id(sourcePerson), targetNode: id(targetPerson), relationshipWeightProperty: 'weight' })
YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN source, target, totalCost
```

## Data sets

The data sets are on SciLens at `/bigstore/gabor/surf-actual-data-set/actual/lsqb/lsqb-projected/`.
