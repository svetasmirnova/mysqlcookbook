#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use Cookbook;

# Create CGI object for accessing CGI.pm methods
my $cgi = new CGI;
# Print header, blank line, and initial part of page
print $cgi->header ();
print $cgi->start_html (-title => "Perl Web Connect Page");
# Connect to and disconnect from database
my $dbh = Cookbook::connect ();
print $cgi->p ("Connected");
$dbh->disconnect ();
print $cgi->p ("Disconnected");
# Print page trailer
print $cgi->end_html ();
