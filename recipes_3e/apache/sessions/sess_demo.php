<?php
# sess_demo.php: Simple session-stage counter.

# Uses PHP's default (file-based) session storage managment.

session_start ();
$count = $_SESSION["count"];
if (!isset ($count))
  $count = 0;
++$count;
$_SESSION["count"] = $count;
?>
<html>
<head><title>Session Demo</title></head>
<body>

<p>
<?php
print ("<p>This session has been active for $count requests.</p>");
print ("<p>Reload page to send next request.</p>");
?>
</p>

</body>
</html>
