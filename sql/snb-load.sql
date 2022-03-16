COPY Person                    FROM 'PATHVAR/Person.csv'                    (DELIMITER '|', HEADER, FORMAT csv);
COPY Person_knows_Person (Person1id, Person2id) FROM 'PATHVAR/Person_knows_Person.csv'       (DELIMITER '|', HEADER, FORMAT csv);
COPY Person_knows_Person (Person2id, Person1id) FROM 'PATHVAR/Person_knows_Person.csv'       (DELIMITER '|', HEADER, FORMAT csv);
