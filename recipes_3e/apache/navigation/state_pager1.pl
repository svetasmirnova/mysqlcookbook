#!/usr/bin/perl
# state_pager1.pl: paged display of states, with prev-page/next-page links

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

# If start > 1, then we'll need a live "previous page" link.
# To determine whether there is a next page, try to select one more
# record than we need.  If we get that many, display only the first
# $per_page records, but add a live "next page" link.

# Select the records in the current page of the result set, and
# attempt to get an extra record.  (If we get the extra one, we
# won't display it, but its presence tells us there is a next
# page.)

my $stmt = sprintf ("SELECT name, abbrev, statehood, pop
                     FROM states
                     ORDER BY name LIMIT %d,%d",
                    $start - 1,       # number of records to skip
                    $per_page + 1);   # number of records to select
        
my $tbl_ref = $dbh->selectall_arrayref ($stmt);

$dbh->disconnect ();

# Display results as HTML table
my @rows;
push (@rows, Tr (th (["Name", "Abbreviation", "Statehood", "Population"])));
for (my $i = 0; $i < $per_page && $i < @{$tbl_ref}; $i++)
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

# If we're not at the beginning of the query result, present a live
# link to the previous page.  Otherwise, present static text.

if ($start > 1)         # live link
{
  my $url = sprintf ("%s?start=%d;per_page=%d",
                     url (),
                     $start - $per_page,
                     $per_page);
  $page .= "[" . a ({-href => $url}, "previous page") . "] ";
}
else                    # static text
{
  $page .= "[previous page]";
}

# If we got the extra record, present a live link to the next page.
# Otherwise, present static text.

if (@{$tbl_ref} > $per_page)  # live link
{
  my $url = sprintf ("%s?start=%d;per_page=%d",
                     url (),
                     $start + $per_page,
                     $per_page);
  $page .= "[" . a ({-href => $url}, "next page") . "]";
}
else                          # static text
{
  $page .= "[next page]";
}

$page .= end_html ();

print $page;
