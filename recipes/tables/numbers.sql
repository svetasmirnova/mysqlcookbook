# numbers.sql

DROP TABLE IF EXISTS `numbers`;
#@ _CREATE_TABLE_
CREATE TABLE `numbers` (
  `i` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `numbers` VALUES (1),(2),(3),(4);

SELECT * FROM numbers;
