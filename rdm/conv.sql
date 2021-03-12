DROP TABLE person_vertices;
DROP TABLE person_knows_person_edges;

-- mapping vertices

CREATE TABLE person_vertices (sparse_id integer, dense_id integer, degree integer);
INSERT INTO person_vertices
    SELECT sparse_id, rnum - 1, count(person2id)
    FROM (
        SELECT person.id AS sparse_id, row_number() OVER () AS rnum
        FROM person
    ) person_mapping
    JOIN person_knows_person
    ON sparse_id = person_knows_person.person1id
    GROUP BY sparse_id, rnum
;

-- mapping edges
CREATE TABLE person_knows_person_edges (src integer, trg integer);
INSERT INTO person_knows_person_edges
    SELECT person1.dense_id, person2.dense_id
    FROM person_knows_person
    JOIN person_vertices person1
    ON person1.sparse_id = person_knows_person.person1id
    JOIN person_vertices person2
    ON person2.sparse_id = person_knows_person.person2id
    WHERE person1.dense_id < person2.dense_id;
    

-- serialization
COPY (SELECT 'v', dense_id, 0, degree FROM person_vertices)
  TO '/tmp/v.csv'
  WITH (DELIMITER ' ');
COPY (SELECT 'e', src, trg FROM person_knows_person_edges)
  TO '/tmp/e.csv'
  WITH (DELIMITER ' ');
