#!/usr/bin/perl
# sess_track.pl: session request counting/timestamping demonstration

use strict;
use warnings;
use CGI qw(:standard);
use Cookbook;
use Apache::Session::MySQL;

my $title = "Perl Session Tracker";

my $dbh = Cookbook::connect ();       # connection to MySQL
my $sess_id = cookie ("PERLSESSID");  # session ID (undef if new session)
my %session;                          # session hash
my $cookie;                           # cookie to send to client

# open the session

tie %session,
    "Apache::Session::MySQL",
    $sess_id,
    {
      Handle     => $dbh,
      LockHandle => $dbh,
      TableName  => "perl_session"
    };
if (!defined ($sess_id))          # this is a new session
{
  # get new session ID, initialize session data, create cookie for client
  $sess_id = $session{_session_id};
  $session{count} = 0;            # initialize counter
  $session{timestamp} = [];       # initialize timestamp array
  $cookie = cookie (-name => "PERLSESSID", -value => $sess_id);
}

# increment counter and add current timestamp to timestamp array

++$session{count};
push (@{$session{timestamp}}, scalar (localtime (time ())));

# construct content of page body

my $page_body =
    p ("This session has been active for $session{count} requests.")
    . p ("The requests occurred at these times:")
    . ol (li ($session{timestamp}))
    . p ("Reload page to send next request.");

if ($session{count} < 10) # close (and save) session
{
  untie (%session);
}
else                      # destroy session after 10 invocations
{
  tied (%session)->delete ();
  # reset cookie to tell browser to discard session cookie
  $cookie = cookie (-name    => "PERLSESSID",
                    -value   => $sess_id,
                    -expires => "-1d");   # "expire yesterday"
}

$dbh->disconnect ();

# generate the output page; include cookie in headers if it's defined

print header (-cookie => $cookie)
      . start_html (-title => $title)
      . $page_body
      . end_html ();
