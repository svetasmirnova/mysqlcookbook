#!/usr/bin/perl
# hits.pl: web page hit-counter example

use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;

my $title = "Hit Count Example";

print header (), start_html (-title => $title);

my $dbh = Cookbook::connect ();

print p ("Page path: " . escapeHTML (script_name ()));

# Display a hit count

#@ _DISPLAY_HIT_COUNT_
my $count = get_hit_count ($dbh, script_name ());
print p ("This page has been accessed $count times.");
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This enables
# the most recent hits to be displayed.

my $host = $ENV{REMOTE_HOST} || $ENV{REMOTE_ADDR} || "UNKNOWN";

$dbh->do ("INSERT INTO hitlog (path, host) VALUES(?,?)",
          undef, script_name (), $host);

# Display the most recent hits for the page

my $sth = $dbh->prepare (qq{
                  SELECT DATE_FORMAT(t, '%Y-%m-%d %T'), host
                  FROM hitlog
                  WHERE path = ? ORDER BY t DESC LIMIT 10
                });
$sth->execute (script_name ());
my @rows;
push (@rows, Tr (th ([ "Date", "Host" ])));
while (my @val = $sth->fetchrow_array ())
{
  push (@rows, Tr (td ([ map { escapeHTML ($_) } @val ])));
}

print p ("Most recent hits:");
print table ({-border => 1}, @rows);

$dbh->disconnect ();

print end_html ();

#@ _GET_HIT_COUNT_
sub get_hit_count
{
my ($dbh, $page_path) = @_;

#@ _UPDATE_COUNTER_
  $dbh->do ("INSERT INTO hitcount (path,hits) VALUES(?,LAST_INSERT_ID(1))
             ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)",
            undef, $page_path);
#@ _UPDATE_COUNTER_
  return $dbh->{mysql_insertid};
}
#@ _GET_HIT_COUNT_
