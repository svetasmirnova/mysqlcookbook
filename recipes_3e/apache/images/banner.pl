#!/usr/bin/perl
#@ _MAIN_PROGRAM_
# banner.pl: serve randomly chosen banner ad from image table
# (sends no response if no image can be found)

use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;

my $dbh = Cookbook::connect ();
my ($type, $data) = $dbh->selectrow_array (
                            "SELECT type, data FROM image
                             ORDER BY RAND() LIMIT 1");
$dbh->disconnect ();

# Send image to client, preceded by Content-Type: and
# Content-Length: headers.  The Expires:, Cache-Control:, and
# Pragma: headers help keep browsers from caching the image
# and reusing it for successive requests for this script.

if (defined ($type))
{
  print header (-type => $type,
                -Content_Length => length ($data),
                -Cache_Control => "no-cache",
                -Pragma => "no-cache",
                -expires => "-1d");
  print $data;
}
#@ _MAIN_PROGRAM_
