#!/usr/bin/perl
# mysql_status.pl: print some MySQL server status information
# by generating HTML directly

use strict;
use warnings;
use Cookbook;

# Print header, blank line, and initial part of page
print <<EOF;
Content-Type: text/html

<html>
<head><title>MySQL Server Status</title></head>
<body>
EOF

# Connect to database
my $dbh = Cookbook::connect ();

# Retrieve status information
my ($now, $version) = $dbh->selectrow_array ("SELECT NOW(), VERSION()");
# SHOW STATUS variable values are in second result column
my $queries = ($dbh->selectrow_array ("SHOW GLOBAL STATUS
                                       LIKE 'Questions'"))[1];
my $uptime = ($dbh->selectrow_array ("SHOW GLOBAL STATUS
                                      LIKE 'Uptime'"))[1];
my $q_per_sec = sprintf ("%.2f", $queries/$uptime);

# Disconnect from database
$dbh->disconnect ();

# Display status report
print "<p>Current time: $now</p>";
print "<p>Server version: $version</p>";
print "<p>Server uptime (seconds): $uptime</p>";
print "<p>Queries processed:  $queries ($q_per_sec queries/second)</p>";

# Print page trailer
print <<EOF;
</body>
</html>
EOF
