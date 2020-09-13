# app_log.sql

# Create an application log table for recording application uses.

DROP TABLE IF EXISTS app_log;
#@ _CREATE_TABLE_
CREATE TABLE app_log
(
  t     TIMESTAMP,
  user  CHAR(16),
  host  CHAR(60)
);
#@ _CREATE_TABLE_
