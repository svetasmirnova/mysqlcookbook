<?php
# download.php: retrieve result set and send it to user as a download
# rather than for display in a web page

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Result Set Downloading Example";

# If no download parameter is present, display instruction page

if (!get_param_val ("download"))
{
  # construct self-referential URL that includes download parameter
  $url = $_SERVER["PHP_SELF"] . "?download=1";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>
<p>
Select the following link to commence downloading:
<a href="<?php print ($url); ?>">download</a>
</p>
</body>
</html>

<?php
  exit ();
} # end of "if"

# The download parameter was present; retrieve a result set and send
# it to the client as a tab-delimited, newline-terminated document.
# Use a content type of application/octet-stream in an attempt to
# trigger a download response by the browser, and suggest a default
# filename of "result.txt".

$dbh = Cookbook::connect ();

$stmt = "SELECT * FROM profile";
$sth = $dbh->query ($stmt);

header ('Content-Type: application/octet-stream');
header ('Content-Disposition: attachment; filename="result.txt"');

while ($row = $sth->fetch (PDO::FETCH_NUM))
  print (implode ("\t", $row) . "\n");

$dbh = NULL;
?>
