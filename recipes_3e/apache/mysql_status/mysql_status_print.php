<?php
# mysql_status_print.php: print some MySQL server status information
# using print() to generate all HTML

require_once "Cookbook.php";

# Helper function: execute a query, return first result row as an array

function fetch_row ($dbh, $stmt)
{
  $sth = $dbh->query ($stmt);
  return ($sth->fetch (PDO::FETCH_NUM));
}

print ("<html>\n");
print ("<head><title>MySQL Server Status</title></head>\n");
print ("<body>\n");

# Connect to database
try
{
  $dbh = Cookbook::connect ();
}
catch (PDOException $e)
{
  die ("Cannot connect to server: "
       . htmlspecialchars ($e->getMessage ()));
}

# Retrieve status information
list ($now, $version) = fetch_row ($dbh, "SELECT NOW(), VERSION()");
# SHOW STATUS variable values are in second result column
list ($junk, $queries) =
  fetch_row ($dbh, "SHOW GLOBAL STATUS LIKE 'Questions'");
list ($junk, $uptime) =
  fetch_row ($dbh, "SHOW GLOBAL STATUS LIKE 'Uptime'");
$q_per_sec = sprintf ("%.2f", $queries/$uptime);

# Disconnect from database
$dbh = NULL;

# Display status report
print ("<p>Current time: $now</p>\n");
print ("<p>Server version: $version</p>\n");
print ("<p>Server uptime (seconds): $uptime</p>\n");
#@ _QUERIES_
print ("<p>Queries processed:  $queries ($q_per_sec queries/second)</p>\n");
#@ _QUERIES_

print ("</body>\n");
print ("</html>\n");
?>
