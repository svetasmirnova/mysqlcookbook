# kjv.sql

# Table to hold verses of the King James Version of the Bible

# Table is created explicitly as MyISAM because any MySQL server
# should support FULLTEXT indexes for MyISAM tables.  If your server
# supports FULLTEXT for InnoDB (MySQL 5.6 or higher), you can modify
# the ENGINE clause to ENGINE = InnoDB.

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
) ENGINE = MyISAM;                 # can be InnoDB for MySQL 5.6+
#@ _CREATE_TABLE_

# Add other indexes to the kjv table, to help queries that
# search on other columns

ALTER TABLE kjv
  ADD INDEX (bnum),
  ADD INDEX (bsect),
  ADD INDEX (cnum),
  ADD INDEX (vnum);
