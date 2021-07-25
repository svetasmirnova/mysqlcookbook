#person.sql

DROP TABLE IF EXISTS `person`;
#@ _CREATE_TABLE_
  `last_name` char(20) NOT NULL,
  `first_name` char(20) NOT NULL,
  `address` char(40) DEFAULT NULL,
  PRIMARY KEY (`last_name`,`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
#@ _CREATE_TABLE_

SELECT * FROM person;
