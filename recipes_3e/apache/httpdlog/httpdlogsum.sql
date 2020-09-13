# httpdlogsum.sql

# some queries to summaries contents of httpdlog table

#@ _TOTAL_RECORDS_
SELECT COUNT(*) FROM httpdlog;
#@ _TOTAL_RECORDS_
#@ _DISTINCT_HOSTS_
SELECT COUNT(DISTINCT host) FROM httpdlog;
#@ _DISTINCT_HOSTS_
#@ _DISTINCT_URLS_
SELECT COUNT(DISTINCT url) FROM httpdlog;
#@ _DISTINCT_URLS_

#SELECT url, COUNT(*) AS count FROM httpdlog GROUP BY url;

# 10 most popular requests
#@ _COUNT_URLS_
SELECT url, COUNT(*) AS count FROM httpdlog
GROUP BY url ORDER BY count DESC LIMIT 10;
#@ _COUNT_URLS_

SELECT DISTINCT method, COUNT(*) AS requests FROM httpdlog
GROUP BY method;

# total traffic

#@ _TOTAL_TRAFFIC_
SELECT
  COUNT(size) AS requests,
  SUM(size) AS bytes,
  AVG(size) AS 'bytes/request'
FROM httpdlog;
#@ _TOTAL_TRAFFIC_

# amount of traffic per file extension, for requests that have an extension

#@ _TRAFFIC_PER_EXTENSION_
SELECT
  SUBSTRING_INDEX(SUBSTRING_INDEX(url,'?',1),'.',-1) AS extension,
  COUNT(size) AS requests,
  SUM(size) AS bytes,
  AVG(size) AS 'bytes/request'
FROM httpdlog
WHERE url LIKE '%.%'
GROUP BY extension;
#@ _TRAFFIC_PER_EXTENSION_

# longest URL recorded in table

#@ _LONGEST_URL_
SELECT MAX(LENGTH(url)) FROM httpdlog;
#@ _LONGEST_URL_

# status values

SELECT status, COUNT(*) AS '# requests' FROM httpdlog GROUP BY status;

# number of useless requests for favicon.ico

SELECT 'Useless favicon requests:';

#@ _USELESS_FAVICON_
SELECT COUNT(*) FROM httpdlog WHERE url LIKE '%/favicon.ico%';
#@ _USELESS_FAVICON_

#@ _DATE_RANGE_
SELECT MIN(dt), MAX(dt) FROM httpdlog;
#@ _DATE_RANGE_

#@ _REQUESTS_PER_DAY_
SELECT DATE(dt) AS day, COUNT(*) FROM httpdlog GROUP BY day;
#@ _REQUESTS_PER_DAY_

#@ _REQUESTS_PER_HOUR_
SELECT HOUR(dt) AS hour, COUNT(*) FROM httpdlog GROUP BY hour;
#@ _REQUESTS_PER_HOUR_

#@ _DAILY_REQUEST_RATE_
SELECT COUNT(*)/(DATEDIFF(MAX(dt), MIN(dt)) + 1) FROM httpdlog;
#@ _DAILY_REQUEST_RATE_
