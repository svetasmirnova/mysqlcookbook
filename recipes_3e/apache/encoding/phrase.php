<?php
# phrase.php: demonstrate HTML-encoding and URL-encoding using
# values in phrase table.

require_once "Cookbook.php";

$title = "Links generated from phrase table";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
print ("<p>$title</p>");

$dbh = Cookbook::connect ();

#@ _MAIN_
$stmt = "SELECT phrase_val FROM phrase ORDER BY phrase_val";
$sth = $dbh->query ($stmt);
while (list ($phrase) = $sth->fetch (PDO::FETCH_NUM))
{
  # URL-encode the phrase value for use in the URL
  $url = "/mcb/mysearch.php?phrase=" . urlencode ($phrase);
  # HTML-encode the phrase value for use in the link label
  $label = htmlspecialchars ($phrase);
  printf ('<a href="%s">%s</a><br />', $url, $label);
}
#@ _MAIN_

$dbh = NULL;
?>
