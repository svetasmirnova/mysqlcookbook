<?php
# paragraphs.php: generate HTML paragraphs

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Query Output Display - Paragraphs";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
$dbh = Cookbook::connect ();

#@ _DISPLAY_PARAGRAPH_1_
$sth = $dbh->query ("SELECT NOW(), VERSION(), DATABASE()");
list ($now, $version, $db) = $sth->fetch (PDO::FETCH_NUM);
if ($db === NULL)
  $db = "NONE";
$para = "Local time on the MySQL server is $now.";
print ("<p>" . htmlspecialchars ($para) . "</p>");
$para = "The server version is $version.";
print ("<p>" . htmlspecialchars ($para) . "</p>");
$para = "The default database is $db.";
print ("<p>" . htmlspecialchars ($para) . "</p>");
#@ _DISPLAY_PARAGRAPH_1_

$dbh = NULL;

# Display the paragraph with a lot of switching between modes
?>

<!-- _DISPLAY_PARAGRAPH_2_ -->
<p>Local time on the MySQL server is
<?php print (htmlspecialchars ($now)); ?>.</p>
<p>The server version is
<?php print (htmlspecialchars ($version)); ?>.</p>
<p>The default database is
<?php print (htmlspecialchars ($db)); ?>.</p>
<!-- _DISPLAY_PARAGRAPH_2_ -->

</body>
</html>
