#!/usr/bin/perl
# state_list.pl: single-page list of states, with navigation index
# to each group of state names that begin with a given letter

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "US State List";

my $page = header ()
           . start_html (-title => $title)
           . h3 ($title);

my $dbh = Cookbook::connect ();

# collect state names and associate each with the proper
# initial-letter list
my $sth = $dbh->prepare ("SELECT name FROM states ORDER BY name");
$sth->execute ();
my %ltr;
while (my ($name) = $sth->fetchrow_array ())
{
  my $ltr = uc (substr ($name, 0, 1));
  # initialize letter list to empty array if this is
  # first state for it, then add state to array
  $ltr{$ltr} = [] unless exists ($ltr{$ltr});
  push (@{$ltr{$ltr}}, $name);
}

# Determine all letters that state names begin with and use them
# to construct a navigation index.  These are links of the form
# <a href="#ltr>ltr</a>, where '#' signifies a within-page link.
# No URL- or HTML-encoding is done here (single letters from the
# alphabet don't need it).  Separate links by nonbreaking spaces.

my $nav_index
  = join ("&nbsp;", map { a ({-href => "#$_"}, $_) } sort (keys (%ltr)));

# Now display list of states for each letter.  Precede each section with
# a label that shows the letter the names in the section begin with, and
# a copy of the navigation index.

foreach my $ltr (sort (keys (%ltr)))
{
  # add an <a name> anchor for this section of the state display
  $page .= p (a ({-name => $ltr}, font ({-size => "+2"}, $ltr))
           . "&nbsp;"
           . $nav_index);
  # encode list of state names for this letter, generate unordered list
  $page .= ul (li ([ map { escapeHTML ($_) } @{$ltr{$ltr}} ]));
}

$dbh->disconnect ();

$page .= end_html ();

print $page;
