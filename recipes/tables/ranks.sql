# ranks.sql

DROP TABLE IF EXISTS `ranks`;
#@ _CREATE_TABLE_
CREATE TABLE `ranks` (
  `score` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
#@ _CREATE_TABLE_

INSERT INTO `ranks` VALUES (5),(4),(4),(3),(2),(2),(2),(1);

SELECT * FROM ranks;
