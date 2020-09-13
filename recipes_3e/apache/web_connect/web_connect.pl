#!/usr/bin/perl

use strict;
use warnings;
use Cookbook;

# Print header, blank line, and initial part of page
print <<EOF;
Content-Type: text/html

<html>
<head><title>Perl Web Connect Page</title></head>
<body>
EOF
# Connect to and disconnect from database
my $dbh = Cookbook::connect ();
print "<p>Connected</p>\n";
$dbh->disconnect ();
print "<p>Disconnected</p>\n";
# Print page trailer
print <<EOF;
</body>
</html>
EOF
