#!/usr/bin/perl
# mysql_status_oo.pl: print some MySQL server status information
# using the CGI.pm object-oriented interface

use strict;
use warnings;
use CGI;
use Cookbook;

# Create CGI object for accessing CGI.pm methods
my $cgi = new CGI;

# Print header, blank line, and initial part of page
print $cgi->header ();
print $cgi->start_html (-title => "MySQL Server Status");

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
print $cgi->p ("Current time: $now");
print $cgi->p ("Server version: $version");
print $cgi->p ("Server uptime (seconds): $uptime");
print $cgi->p ("Queries processed:  $queries ($q_per_sec queries/second)");

# Print page trailer
print $cgi->end_html ();
