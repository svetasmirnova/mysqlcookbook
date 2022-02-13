# sibling.sql

# Date of birth for the Alkin's  children.  Used for age calculations

DROP TABLE IF EXISTS sibling;
CREATE TABLE sibling
(
  name  CHAR(20),
  birth DATE,
  PRIMARY KEY(name)
);

INSERT INTO sibling (name,birth) VALUES('Ilayda','2002-12-17');
INSERT INTO sibling (name,birth) VALUES('Lara','2009-06-03');

SELECT * FROM sibling;
