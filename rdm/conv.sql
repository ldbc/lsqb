DROP TABLE IF EXISTS vertex_mapping;
DROP TABLE IF EXISTS label_mapping;

CREATE TABLE vertex_mapping (sparse_id BIGINT, label VARCHAR, dense_id BIGINT, degree VARCHAR);

CREATE TABLE label_mapping (label VARCHAR, numeric_label INTEGER);
INSERT INTO label_mapping VALUES
    ('Person', 0),
    ('City', 1),
    ('Country', 2)
    ;

DROP VIEW IF EXISTS vertices;
CREATE VIEW vertices AS
    SELECT id, 'Person'  AS label FROM Person
    UNION ALL
    SELECT id, 'City'    AS label FROM City
    UNION ALL
    SELECT id, 'Country' AS label FROM Country
;

DROP VIEW IF EXISTS edges;
CREATE VIEW edges
           AS SELECT person1id AS sourceId, person2id AS targetId,  'Person' AS sourceLabel, 'Person'  AS targetLabel FROM Person_knows_Person
               WHERE person1id < person2id
    UNION ALL SELECT id AS sourceId, isLocatedIn_Place AS targetId, 'Person' AS sourceLabel, 'City'    AS targetLabel FROM Person
    UNION ALL SELECT id AS sourceId, isPartOf_Country AS targetId,  'City'   AS sourceLabel, 'Country' AS targetLabel FROM City
;

DROP VIEW IF EXISTS undirected_edges;
CREATE VIEW undirected_edges AS
    SELECT sourceId, targetId, sourceLabel, targetLabel FROM edges
    UNION ALL
    SELECT targetId, sourceId, targetLabel, sourceLabel FROM edges
;

INSERT INTO vertex_mapping
    SELECT sparse_id, label, rnum - 1 AS dense_id, count(targetId) AS degree
    FROM (SELECT id AS sparse_id, label, row_number() OVER () AS rnum FROM vertices) mapping
    JOIN undirected_edges
      ON sparse_id = sourceId AND label = sourceLabel
    GROUP BY sparse_id, label, rnum
    ORDER BY dense_id
;

DROP TABLE IF EXISTS edge_mapping;
CREATE TABLE edge_mapping(sourceId BIGINT, targetId BIGINT);
INSERT INTO edge_mapping
    SELECT source_mapping.dense_id AS sourceId, target_mapping.dense_id AS targetId
    FROM edges
    JOIN vertex_mapping source_mapping
      ON source_mapping.sparse_id = edges.sourceId
     AND source_mapping.label = edges.sourceLabel
    JOIN vertex_mapping target_mapping
      ON target_mapping.sparse_id = edges.targetId
     AND target_mapping.label = edges.targetLabel
;

-- serialization

COPY (
  SELECT concat('t', ' ', vertex_mapping_count.count, ' ', edge_mapping_count.count) AS tuple
    FROM
      (SELECT count(*) AS count FROM vertex_mapping) vertex_mapping_count,
      (SELECT count(*) AS count FROM edge_mapping) edge_mapping_count
  UNION ALL
  SELECT concat('v', ' ', dense_id, ' ', numeric_label, ' ', degree) FROM vertex_mapping
    JOIN label_mapping
     ON vertex_mapping.label = label_mapping.label
  UNION ALL
  SELECT concat('e', ' ', sourceId, ' ', targetId) FROM edge_mapping
)
TO '/tmp/my.graph'
WITH (DELIMITER ' ', QUOTE '');
