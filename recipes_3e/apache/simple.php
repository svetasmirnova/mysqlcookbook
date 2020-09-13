<html>
<head><title>Simple PHP Page</title></head>
<body>
<p>Hello.</p>
<p>Current date: <?php print (date ("D M d H:i:s T Y")); ?></p>
<p>Your IP address: <?php print ($_SERVER["REMOTE_ADDR"]); ?></p>
</body>
</html>
