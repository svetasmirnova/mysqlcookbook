#!/usr/bin/perl
# mysql_status_fc.pl: print some MySQL server status information
# using the CGI.pm function-call interface

use strict;
use warnings;
use CGI qw(:standard);  # import standard method names into script namespace
use Cookbook;

# Print header, blank line, and initial part of page
print header ();
print start_html (-title => "MySQL Server Status");

# Connect to database
my $dbh = Cookbook::connect ();

# Retrieve status information
my ($now, $version) = $dbh->selectrow_array ("SELECT NOW(), VERSION()");
# SHOW STATUS variable values are in second result column
my $queries = ($dbh->selectrow_array (
                "SHOW GLOBAL STATUS LIKE 'Questions'"))[1];
my $uptime = ($dbh->selectrow_array (
                "SHOW GLOBAL STATUS LIKE 'Uptime'"))[1];
my $q_per_sec = sprintf ("%.2f", $queries/$uptime);

# Disconnect from database
$dbh->disconnect ();

# Display status report
print p ("Current time: $now");
print p ("Server version: $version");
print p ("Server uptime (seconds): $uptime");
print p ("Queries processed:  $queries ($q_per_sec queries/second)");

# Print page trailer
print end_html ();
