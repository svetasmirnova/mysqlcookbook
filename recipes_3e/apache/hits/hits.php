<?php
# hits.php: web page hit-counter example

require_once "Cookbook.php";
require_once "Cookbook_Utils.php";
require_once "Cookbook_Webutils.php";

$title = "Hit Count Example";

#@ _GET_HIT_COUNT_
function get_hit_count ($dbh, $page_path)
{
  $stmt = "INSERT INTO hitcount (path,hits)
           VALUES(?,LAST_INSERT_ID(1))
           ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)";
  $sth = $dbh->prepare ($stmt);
  $sth->execute (array ($page_path));
  $stmt = "SELECT LAST_INSERT_ID()";
  $sth = $dbh->query ($stmt);
  list ($hits) = $sth->fetch (PDO::FETCH_NUM);
  return ($hits);
}
#@ _GET_HIT_COUNT_
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
$dbh = Cookbook::connect ();

#@ _GET_SELF_PATH_
$self_path = $_SERVER["PHP_SELF"];
#@ _GET_SELF_PATH_

printf ("<p>Page path: %s</p>", htmlspecialchars ($self_path));

# Display a hit count

#@ _DISPLAY_HIT_COUNT_
$count = get_hit_count ($dbh, $self_path);
print ("<p>This page has been accessed $count times.</p>");
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This enables
# the most recent hits to be displayed.

$host = get_server_val ("REMOTE_HOST");
if (!isset ($host))
  $host = get_server_val ("REMOTE_ADDR");
if (!isset ($host))
  $host = "UNKNOWN";

$stmt = "INSERT INTO hitlog (path, host) VALUES(?,?)";
$sth = $dbh->prepare ($stmt);
$sth->execute (array ($self_path, $host));

# Display the most recent hits for the page

$stmt = "SELECT DATE_FORMAT(t, '%Y-%m-%d %T'), host
         FROM hitlog WHERE path = ? ORDER BY t DESC LIMIT 10";
$sth = $dbh->prepare ($stmt);
$sth->execute (array ($self_path));
print ('<p>Most recent hits:</p>');
print ('<table border="1">');
printf ('<tr><th>%s</th><th>%s</th></tr>', 'Date', 'Host');
while (list ($date, $host) = $sth->fetch (PDO::FETCH_NUM))
{
  printf ('<tr><td>%s</td><td>%s</td></tr>',
          htmlspecialchars ($date),
          htmlspecialchars ($host));
}
print ('</table>');

$dbh = NULL;
?>

</body>
</html>
