DROP TABLE IF EXISTS person_vertices;
DROP TABLE IF EXISTS person_knows_person_edges;

-- mapping vertices

CREATE TABLE person_vertices (sparse_id long, dense_id long, degree long);
INSERT INTO person_vertices
    SELECT sparse_id, rnum - 1 AS dense_id, count(person2id) AS degree
    FROM (
        SELECT person.id AS sparse_id, row_number() OVER () AS rnum
        FROM person
    ) person_mapping
    LEFT JOIN person_knows_person
    ON sparse_id = person_knows_person.person1id
    GROUP BY sparse_id, rnum
    ORDER BY dense_id
;

-- mapping edges
CREATE TABLE person_knows_person_edges (src long, trg long);
INSERT INTO person_knows_person_edges
    SELECT person1.dense_id, person2.dense_id
    FROM person_knows_person
    JOIN person_vertices person1
    ON person1.sparse_id = person_knows_person.person1id
    JOIN person_vertices person2
    ON person2.sparse_id = person_knows_person.person2id
    WHERE person1.dense_id < person2.dense_id;
    

-- serialization
COPY (
  SELECT concat('t', ' ',
    person_vertices_count.count, ' ',
    person_knows_person_edges_count.count)
    FROM
      (SELECT count(*) AS count FROM person_vertices) person_vertices_count,
      (SELECT count(*) AS count FROM person_knows_person_edges) person_knows_person_edges_count
  UNION ALL
  SELECT concat('v', ' ', dense_id, ' ', 0, ' ', degree) FROM person_vertices
  UNION ALL
  SELECT concat('e', ' ', src, ' ', trg) FROM person_knows_person_edges
)
TO '/tmp/my.graph'
WITH (DELIMITER ' ', QUOTE '');
