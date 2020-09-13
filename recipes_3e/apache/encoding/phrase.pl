#!/usr/bin/perl
# phrase.pl: demonstrate HTML-encoding and URL-encoding using
# values in phrase table.

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "Links generated from phrase table";

print header (), start_html (-title => $title);

print p ($title);

my $dbh = Cookbook::connect ();

#@ _MAIN_
my $stmt = "SELECT phrase_val FROM phrase ORDER BY phrase_val";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
while (my ($phrase) = $sth->fetchrow_array ())
{
  # URL-encode the phrase value for use in the URL
  my $url = "/cgi-bin/mysearch.pl?phrase=" . escape ($phrase);
  # HTML-encode the phrase value for use in the link label
  my $label = escapeHTML ($phrase);
  print a ({-href => $url}, $label), br ();
}
#@ _MAIN_

$dbh->disconnect ();
