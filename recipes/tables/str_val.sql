# str_val.sql

DROP TABLE IF EXISTS str_val;
#@ _CREATE_TABLE_
CREATE TABLE str_val
(
  ci_str   CHAR(3) CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  cs_str   CHAR(3) CHARACTER SET latin1 COLLATE latin1_general_cs,
  bin_str  BINARY(3)
);
#@ _CREATE_TABLE_

INSERT INTO str_val (ci_str,cs_str,bin_str) VALUES
('AAA','AAA','AAA'),
('aaa','aaa','aaa'),
('bbb','bbb','bbb'),
('BBB','BBB','BBB');

SELECT * FROM str_val;
SELECT * FROM str_val ORDER BY ci_str;
SELECT * FROM str_val ORDER BY cs_str;
SELECT * FROM str_val ORDER BY bin_str;
