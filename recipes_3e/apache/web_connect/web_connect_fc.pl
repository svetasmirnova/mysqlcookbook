#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);  # import standard method names into script namespace
use Cookbook;

# Print header, blank line, and initial part of page
print header ();
print start_html (-title => "Perl Web Connect Page");
# Connect to and disconnect from database
my $dbh = Cookbook::connect ();
print p ("Connected");
$dbh->disconnect ();
print p ("Disconnected");
# Print page trailer
print end_html ();
