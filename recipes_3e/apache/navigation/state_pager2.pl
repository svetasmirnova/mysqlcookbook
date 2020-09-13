#!/usr/bin/perl
# state_pager2.pl: paged display of states, with links to each page of result

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "Paged US State List";

my $page = header ()
           . start_html (-title => $title)
           . h3 ($title);

my $dbh = Cookbook::connect ();

# Collect parameters that determine where we are in the display and
# verify that they are integers.
# Default to beginning of result set, 10 records/page if parameters
# are missing/malformed.

my $start = param ("start");
$start = 1
  if !defined ($start) || $start !~ /^\d+$/ || $start < 1;

my $per_page = param ("per_page");
$per_page = 10
  if !defined ($per_page) || $per_page !~ /^\d+$/ || $per_page < 1;;

#@ _GENERATE_PAGE_CONTENT_
# Determine total number of records

my $total_recs = $dbh->selectrow_array ("SELECT COUNT(*) FROM states");

# Select the records in the current page of the result set

my $stmt = sprintf ("SELECT name, abbrev, statehood, pop
                     FROM states
                     ORDER BY name LIMIT %d,%d",
                    $start - 1,     # number of records to skip
                    $per_page);     # number of records to select
        
my $tbl_ref = $dbh->selectall_arrayref ($stmt);

$dbh->disconnect ();

# Display results as HTML table
my @rows;
push (@rows, Tr (th (["Name", "Abbreviation", "Statehood", "Population"])));
for (my $i = 0; $i < @{$tbl_ref}; $i++)
{
  # get data values in row $i
  my @cells = @{$tbl_ref->[$i]};  # get data values in row $i
  # map values to HTML-encoded values, or to &nbsp; if null/empty
  @cells = map {
             defined ($_) && $_ ne "" ? escapeHTML ($_) : "&nbsp;"
           } @cells;
  # add cells to table
  push (@rows, Tr (td (\@cells)));
}

$page .= table ({-border => 1}, @rows) . br ();

# Generate links to all pages of the result set.  All links are
# live, except the one to the current page, which is displayed as
# static text.  Link label format is "[m to n]" where m and n are
# the numbers of the first and last records displayed on the page.

for (my $first = 1; $first <= $total_recs; $first += $per_page)
{
  my $last = $first + $per_page - 1;
  $last = $total_recs if $last > $total_recs;
  my $label = "$first to $last";
  my $link;

  if ($first != $start) # live link
  {
    my $url = sprintf ("%s?start=%d;per_page=%d",
                       url (),
                       $first,
                       $per_page);
    $link = a ({-href => $url}, $label);
  }
  else                  # static text
  {
    $link = $label;
  }
  $page .= "[$link] ";
}
#@ _GENERATE_PAGE_CONTENT_

$page .= end_html ();

print $page;
