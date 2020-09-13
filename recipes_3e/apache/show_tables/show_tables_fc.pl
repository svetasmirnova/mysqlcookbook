#!/usr/bin/perl
# show_tables_fc.pl: Display names of tables in cookbook database
# (use the CGI.pm function-call interface)

use strict;
use warnings;
use CGI qw(:standard); # import standard method names into script namespace
use Cookbook;

# Print header, blank line, and initial part of page

print header ();
print start_html (-title => "Tables in cookbook Database");

print p ("Tables in cookbook database:");

# Connect to database, display table list, disconnect

my $dbh = Cookbook::connect ();
my $stmt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
while (my @row = $sth->fetchrow_array ())
{
  print $row[0], br ();
}
$dbh->disconnect ();

# Print page trailer

print end_html ();
