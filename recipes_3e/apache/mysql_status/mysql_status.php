<?php
# mysql_status.php: print some MySQL server status information

require_once "Cookbook.php";

# Helper function: execute a query, return first result row as an array

function fetch_row ($dbh, $stmt)
{
  $sth = $dbh->query ($stmt);
  return ($sth->fetch (PDO::FETCH_NUM));
}
?>

<html>
<head><title>MySQL Server Status</title></head>
<body>

<?php
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
?>

<!-- Display status report -->
<p>Current time: <?php print ($now); ?></p>
<p>Server version: <?php print ($version); ?></p>
<p>Server uptime (seconds): <?php print ($uptime); ?></p>
<!-- #@ _QUERIES_ -->
<p>Queries processed:  <?php print ($queries); ?>
 (<?php print ($q_per_sec); ?> queries/second)</p>
<!-- #@ _QUERIES_ -->

</body>
</html>

