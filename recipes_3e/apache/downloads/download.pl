#!/usr/bin/perl
# download.pl: retrieve result set and send it to user as a download
# rather than for display in a web page

use strict;
use warnings;
use CGI qw(:standard);
use Cookbook;

my $title = "Result Set Downloading Example";

# If no download parameter is present, display instruction page

if (!defined (param ("download")))
{
  print header (), start_html (-title => $title);
  # construct self-refential URL that includes download parameter
  print p ("Select the following link to commence downloading: "
        . a ({-href => url () . "?download=1"}, "download"));
  print end_html ();
  exit (0);
}

# The download parameter was present; retrieve a result set and send
# it to the client as a tab-delimited, newline-terminated document.
# Use a content type of application/octet-stream in an attempt to
# trigger a download response by the browser, and suggest a default
# filename of "result.txt".

my $stmt = "SELECT * FROM profile";

my $dbh = Cookbook::connect ();
my $result_ref = $dbh->selectall_arrayref ($stmt);
$dbh->disconnect ();

print header (-type => 'application/octet-stream',
              -Content_Disposition => 'attachment; filename="result.txt"');
foreach my $row_ref (@{$result_ref})
{
  # convert NULL (undef) values to empty strings
  print join ("\t", map { defined ($_) ? $_ : "" } @{$row_ref}), "\n";
}
