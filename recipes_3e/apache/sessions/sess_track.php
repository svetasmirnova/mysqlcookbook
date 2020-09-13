<?php
# sess_track.php: session request counting/timestamping demonstration

#@ _INCLUDE_LIBRARY_
require_once "Cookbook_Session.php";
#@ _INCLUDE_LIBRARY_
require_once "Cookbook_Webutils.php"; # for make_ordered_list()

$title = "PHP Session Tracker";

# Open session and extract session values

session_start ();
$count = $_SESSION["count"];
$timestamp = $_SESSION["timestamp"];

# If the session is new, initialize the variables

if (!isset ($count))
  $count = 0;
if (!isset ($timestamp))
  $timestamp = array ();

# Increment counter, add current timestamp to timestamp array

++$count;
$timestamp[] = date ("Y-m-d H:i:s T");

if ($count < 10)  # save modified values into session
{
  $_SESSION["count"] = $count;
  $_SESSION["timestamp"] = $timestamp;
  session_write_close (); # save session changes
}
else              # destroy session after 10 invocations
{
  session_destroy ();
}

# Produce the output page
?>
<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
print ("<p>This session has been active for $count requests.</p>");
print ("<p>The requests occurred at these times:</p>");
print make_ordered_list ($timestamp);
print ("<p>Reload page to send next request.</p>");
?>

</body>
</html>
