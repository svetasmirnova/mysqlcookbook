#!/usr/bin/perl
# esther2.pl: display the book of Esther over multiple pages,
# one page per chapter, with navigation index

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

# Construct navigation index as a list of links to the pages for each
# chapter in the the book of Esther.  Labels are of the form "Chapter
# n"; the chapter numbers are incorporated into the links as chapter=num
# parameters

# $dbh is the database handle, $cnum is the number of the chapter for
# which information is currently being displayed.  The label in the
# chapter list corresponding to this number is displayed as static
# text; the others are displayed as hyperlinks to the other chapter
# pages.

# No encoding is done because the chapter numbers are digits and don't
# need it.

sub get_chapter_list
{
my ($dbh, $cnum) = @_;

  my $nav_index;
  my $ref = $dbh->selectcol_arrayref (
                      "SELECT DISTINCT cnum FROM kjv
                       WHERE bname = 'Esther' ORDER BY cnum"
                );
  foreach my $cur_cnum (@{$ref})
  {
    my $link = url () . "?chapter=$cur_cnum";
    my $label = "Chapter $cur_cnum";
    $nav_index .= br () if $nav_index;      # separate entries by <br>
    # use static bold text if entry is for current chapter,
    # use a hyperlink otherwise
    $nav_index .= ($cur_cnum == $cnum
                    ? strong ($label)
                    : a ({-href => $link}, $label));
  }
  return $nav_index;
}

# Get the list of verses for a given chapter.  If there are none, the
# chapter number was invalid, but handle that case sensibly.

sub get_verses
{
my ($dbh, $cnum) = @_;

  my $ref = $dbh->selectall_arrayref (
                      "SELECT vnum, vtext FROM kjv
                       WHERE bname = 'Esther' AND cnum = ?",
                      undef, $cnum);
  my $verses = "";
  foreach my $row_ref (@{$ref})
  {
    $verses .= p (escapeHTML ("$row_ref->[0]. $row_ref->[1]"));
  }
  return $verses eq ""     # no verses?
         ? p ("No verses in chapter $cnum were found.")
         : p ("Chapter $cnum:") . $verses;
}

my $title = "The Book of Esther";

my $page = header () . start_html (-title => $title);

my $dbh = Cookbook::connect ();

#@ _CHECK_PARAM_
my $cnum = param ("chapter");
# Missing or malformed chapter; default to chapter 1.
$cnum = 1 if !defined ($cnum) || $cnum !~ /^\d+$/;
#@ _CHECK_PARAM_

# Arrange the page panels as a one-row, three-cell table:
# Left panel: List of chapters as hyperlinks (except for current chapter
# as bold text)
# Middle panel: Spacer
# Right panel: List of current chapter's verses

$page .= table (Tr (
                  td ({-valign => "top", -width => "15%"},
                      get_chapter_list ($dbh, $cnum)),
                  td ({-valign => "top", -width => "5%"}, "&nbsp;"),
                  td ({-valign => "top", -width => "80%"},
                      p (strong ($title)) . get_verses ($dbh, $cnum))
                ));

$dbh->disconnect ();

$page .= end_html ();

print $page;
