# newsstaff.sql

DROP TABLE IF EXISTS newsstaff;
#@ _CREATE_TABLE_
CREATE TABLE newsstaff
(
  department  VARCHAR(60) NOT NULL,
  name        VARCHAR(60) NOT NULL,
  email       VARCHAR(60)
);
#@ _CREATE_TABLE_

INSERT INTO newsstaff (department, name, email)
VALUES
  ('Sports','Becky Winthrop','bwinthrop@wrrr-news.com'),
  ('Weather','Bill Hagburg','bhagburg@wrrr-news.com'),
  ('Local News','Frieda Stevens',NULL), # no email for this one
  ('Local Government','Rex Conex','rconex@wrrr-news.com'),
  ('Current Events','Xavier Ng','xng@wrrr-news.com')
;

SELECT * FROM newsstaff;
