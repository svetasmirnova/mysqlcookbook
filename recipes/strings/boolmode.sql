# boolmode.sql

SELECT COUNT(*) AS 'Abraham' FROM kjv
WHERE MATCH(vtext) AGAINST('Abraham');
SELECT COUNT(*) AS 'Sarah' FROM kjv
WHERE MATCH(vtext) AGAINST('Sarah');
SELECT COUNT(*) AS 'Abraham or Sarah' FROM kjv
WHERE MATCH(vtext) AGAINST('Abraham Sarah');
SELECT COUNT(*) AS 'Abraham' FROM kjv
WHERE MATCH(vtext) AGAINST('+Abraham' IN BOOLEAN MODE);
SELECT COUNT(*) AS 'Sarah' FROM kjv
WHERE MATCH(vtext) AGAINST('+Sarah' IN BOOLEAN MODE);

# The number of verses above containing either Abraham or Sarah
# should be equal to the sum of the next three statements, which
# count the number of verses containing both names, just one name,
# or just the other name.

SELECT COUNT(*) AS 'Abraham and Sarah' FROM kjv
WHERE MATCH(vtext) AGAINST('+Abraham +Sarah' IN BOOLEAN MODE);
SELECT COUNT(*) AS 'Abraham, not Sarah' FROM kjv
WHERE MATCH(vtext) AGAINST('+Abraham -Sarah' IN BOOLEAN MODE);
SELECT COUNT(*) AS 'Sarah, not Abraham' FROM kjv
WHERE MATCH(vtext) AGAINST('-Abraham +Sarah' IN BOOLEAN MODE);
