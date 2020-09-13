<html>
<head><title>PHP Web Connect Page</title></head>
<body>

<?php
require_once "Cookbook.php";

try
{
  $dbh = Cookbook::connect ();
  print ("<p>Connected</p>");
}
catch (PDOException $e)
{
  print ("<p>Cannot connect to server</p>");
  exit (1);
}
$dbh = NULL;
print ("<p>Disconnected</p>");
?>
