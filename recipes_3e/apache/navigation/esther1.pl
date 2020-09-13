#!/usr/bin/perl
# esther1.pl: display the book of Esther in a single page,
# with navigation index

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "The Book of Esther";

my $page = header ()
           . start_html (-title => $title)
           . h3 ($title);

my $dbh = Cookbook::connect ();

# Retrieve verses from the book of Esther and associate each one with the
# list of verses for the chapter it belongs to.

my $sth = $dbh->prepare ("SELECT cnum, vnum, vtext FROM kjv
                          WHERE bname = 'Esther'
                          ORDER BY cnum, vnum");
$sth->execute ();
my %verses;
while (my ($cnum, $vnum, $vtext) = $sth->fetchrow_array ())
{
  # Initialize chapter's verse list to empty array if this is
  # first verse for it, then add verse number/text to array.
  $verses{$cnum} = [] unless exists ($verses{$cnum});
  push (@{$verses{$cnum}}, p (escapeHTML ("$vnum. $vtext")));
}

# Determine all chapter numbers and use them to construct a navigation
# index.  These are links of the form <a href="#num>Chapter num</a>, where
# num is a chapter number and '#' signifies a within-page link.  No URL-
# or HTML-encoding is done here (the text displayed here doesn't need
# it).  Make sure to sort chapter numbers numerically (use { a <=> b }).
# Separate links by nonbreaking spaces.

my $nav_index;
foreach my $cnum (sort { $a <=> $b } keys (%verses))
{
  $nav_index .= "&nbsp;" if $nav_index;
  $nav_index .= a ({-href => "#$cnum"}, "Chapter $cnum");
}

# Display list of verses for each chapter.  Precede each section by a
# label that shows the chapter number and a copy of the navigation index.

foreach my $cnum (sort { $a <=> $b } keys (%verses))
{
  # add an <a name> anchor for this section of the chapter display
  $page .= p (a ({-name => $cnum}, font ({-size => "+2"}, "Chapter $cnum"))
           . br ()
           . $nav_index);
  $page .= join ("", @{$verses{$cnum}});  # add array of verses for chapter
}

$dbh->disconnect ();

$page .= end_html ();

print $page;
