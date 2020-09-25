# kjv.sql

# Table to hold verses of the King James Version of the Bible

DROP TABLE IF EXISTS kjv;
#@ _CREATE_TABLE_
CREATE TABLE kjv
(
  bsect ENUM('O','N') NOT NULL,    # book section (testament)
  bname VARCHAR(20) NOT NULL,      # book name
  bnum  TINYINT UNSIGNED NOT NULL, # book number
  cnum  TINYINT UNSIGNED NOT NULL, # chapter number
  vnum  TINYINT UNSIGNED NOT NULL, # verse number
  vtext TEXT NOT NULL,             # text of verse
  FULLTEXT (vtext)                 # full-text index
);
#@ _CREATE_TABLE_

# Add other indexes to the kjv table, to help queries that
# search on other columns

ALTER TABLE kjv
  ADD INDEX (bnum),
  ADD INDEX (bsect),
  ADD INDEX (cnum),
  ADD INDEX (vnum);
