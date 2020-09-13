# mailday.sql

# Select mail table records, but show day of week


# Sort lexically by day-of-week name

SELECT DISTINCT DAYNAME(t)
FROM mail
ORDER BY DAYNAME(t)
;

# Sort by day-of-week order (Sunday first, Saturday last)

SELECT DISTINCT DAYNAME(t)
FROM mail
ORDER BY DAYOFWEEK(t)
;

# Like previous, but with Tuesday first, Monday last.  Uses a MOD
# trick to map 3,4,5,6,7,1,2 to 1..7

SELECT DISTINCT DAYNAME(t)
FROM mail
ORDER BY MOD(DAYOFWEEK(t) + 4, 7)
;
