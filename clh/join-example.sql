DROP TABLE IF EXISTS r;
DROP TABLE IF EXISTS s;
CREATE TABLE r (a int, b int) engine = Join(ALL, INNER, b);
CREATE TABLE s (b int, c int) engine = MergeTree() ORDER BY b PARTITION BY b;
INSERT INTO r VALUES (1,2), (1,3);
INSERT INTO s VALUES (2,88), (3,99);
SELECT * FROM r JOIN s ON r.b = s.b;
