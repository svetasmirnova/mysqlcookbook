<?php
# show_tables.php: Display names of tables in cookbook database

require_once "Cookbook.php";
?>

<html>
<head><title>Tables in cookbook Database</title></head>
<body>

<p>Tables in cookbook database:</p>

<?php
# Connect to database, display table list, disconnect
$dbh = Cookbook::connect ();
$stmt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
         WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME";
$sth = $dbh->query ($stmt);
while (list ($tbl_name) = $sth->fetch (PDO::FETCH_NUM))
  print ($tbl_name . "<br />");
$dbh = NULL;
?>

</body>
</html>
