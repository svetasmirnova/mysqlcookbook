# sibling.sql

# Date of birth for the Smith children.  Used for age calculations

DROP TABLE IF EXISTS sibling;
CREATE TABLE sibling
(
  name  CHAR(20),
  birth DATE
);

INSERT INTO sibling (name,birth) VALUES('Gretchen','1942-04-14');
INSERT INTO sibling (name,birth) VALUES('Wilbur','1946-11-28');
INSERT INTO sibling (name,birth) VALUES('Franz','1953-03-05');

SELECT * FROM sibling;
