<?php
# show_tables_print.php: Display names of tables in cookbook database
# using print() to generate all HTML

require_once "Cookbook.php";

print ("<html>");
print ("<head><title>Tables in cookbook Database</title></head>");
print ("<body>");
print ("<p>Tables in cookbook database:</p>");

# Connect to database, display table list, disconnect
$dbh = Cookbook::connect ();
$stmt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
         WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME";
$sth = $dbh->query ($stmt);
while (list ($tbl_name) = $sth->fetch (PDO::FETCH_NUM))
  print ($tbl_name . "<br />");
$dbh = NULL;

print ("</body>");
print ("</html>");
?>
