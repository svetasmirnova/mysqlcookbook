# top_names.sql

# Create a table with all fields

DROP TABLE IF EXISTS top_names;
#@ _CREATE_TABLE_

CREATE TABLE top_names (
names_id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
top_name VARCHAR(25),
name_rank SMALLINT,
name_count INT,
prop100k DECIMAL(6,2),
cum_prop100k DECIMAL(6,2),
pctwhite DECIMAL(2,2),
pctblack DECIMAL(2,2),
pctapi DECIMAL(2,2),
pctaian DECIMAL(2,2),
pct2prace DECIMAL(2,2),
pcthispanic DECIMAL(2,2),
PRIMARY KEY (names_id)) 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE 'Names_2010Census.csv' INTO TABLE top_names;
