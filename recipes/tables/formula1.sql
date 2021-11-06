# formula1.sql 

# Table to demonstrate finding number of Sundays in a month. 

DROP TABLE `formula1`;
CREATE TABLE `formula1` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    position INT(2) UNSIGNED,
    no       INT(2) UNSIGNED,
    driver   VARCHAR(25),
    car      VARCHAR(25),
    laps     SMALLINT,
    time     TIMESTAMP(3),
    points   SMALLINT
);

# Load data by inserting all positions

INSERT INTO formula1 VALUES(0,1,77,"Valtteri Bottas","MERCEDES",58,"2021-10-08 1:31:04.103",26);
INSERT INTO formula1 VALUES(0,2,33,"Max Verstappen","RED BULL RACING HONDA",58,"2021-10-08 1:45:58.103",18);
INSERT INTO formula1 VALUES(0,3,11,"Sergio Perez","RED BULL RACING HONDA",58,"2021-10-08 1:46:10.342",15);


# With CTE

SELECT MIN(time) from formula1 into @fastest;
# Select the race standings
WITH time_gap AS (
  SELECT
    position,
    car,
    driver,
    time,
    TIMESTAMPDIFF(SECOND, time , @fastest) AS seconds
  FROM formula1
),
 
differences AS (
  SELECT
    position,
    driver,
    car,
    time,
    seconds,
    MOD(seconds, 60) AS seconds_part,
    MOD(seconds, 3600) AS minutes_part
  FROM time_gap
)
 
SELECT
  position,
  driver,
  car,
  time,
  CONCAT(
    FLOOR(minutes_part / 60), ' minutes ',
    seconds_part, ' seconds'
  ) AS difference
FROM differences;
