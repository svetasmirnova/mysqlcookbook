#!/usr/bin/perl
# paintings.pl: multiple-page list of paintings by artists

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "Paintings";

my $page = header () . start_html (-title => $title);

my ($left_panel, $right_panel);

my $dbh = Cookbook::connect ();

#@ _CHECK_PARAM_
my $artist_id = param ("artist");
if (!defined ($artist_id) || $artist_id !~ /^\d+$/)
#@ _CHECK_PARAM_
{
  # Missing or malformed artist ID; display main page with a left panel
  # that lists all artists as hyperlinks and a right panel that provides
  # instructions.
  $left_panel = get_artist_list ($dbh, 0);
  $right_panel = p ("Select an artist from the list at left.");
}
else
{
  # Artist ID given; display a left panel that lists artists as hyperlinks
  # (except for current artist as bold text) and a right panel that lists
  # the current artist's paintings.
  $left_panel = get_artist_list ($dbh, $artist_id);
  $right_panel = get_painting_list ($dbh, $artist_id);
}

$dbh->disconnect ();

# Arrange the page as a one-row, three-cell table (middle cell is a spacer)

$page .= table (Tr (
                  td ({-valign => "top", -width => "10%"}, $left_panel),
                  td ({-width => "10%"}, ""),
                  td ({-valign => "top", -width => "80%"}, $right_panel)
                ));

$page .= end_html ();

print $page;

# Construct artist list navigation index as a list of links to the pages
# for each artist in the artist table.  Artist names are the labels; artist
# IDs are incorporated into the links as artist=id parameters

# $dbh is the database handle, $artist_id is the ID of the artist for
# which information is currently being displayed.  The label in the artist
# list corresponding to this ID is displayed as static text; the others
# are displayed as hyperlinks to the other artist pages.  Pass 0 to make
# all entries hyperlinks (no artist has ID = 0).

sub get_artist_list
{
my ($dbh, $artist_id) = @_;

  my $nav_index;
  my $ref = $dbh->selectall_arrayref (
                "SELECT a_id, name FROM artist ORDER BY name"
              );
  foreach my $row_ref (@{$ref})
  {
    my $link = sprintf ("%s?artist=%s", url (), escape ($row_ref->[0]));
    my $label = escapeHTML ($row_ref->[1]);
    $nav_index .= br () if $nav_index;      # separate entries by <br>
    # use static bold text if entry is for current artist,
    # use a hyperlink otherwise
    $nav_index .= ($row_ref->[0] eq $artist_id
                    ? strong ($label)
                    : a ({-href => $link}, $label));
  }
  return $nav_index;
}

# Get a list of paintings for a given artist.  If there are none in the
# painting table, say so.  Otherwise, create a table with columns for
# title, state of origin, and price.

sub get_painting_list
{
my ($dbh, $artist_id) = @_;

  my $name = $dbh->selectrow_array (
                "SELECT name FROM artist WHERE a_id = ?", undef, $artist_id
              );
  my $ref = $dbh->selectall_arrayref (
                "SELECT painting.title, states.name, painting.price
                 FROM painting INNER JOIN states
                 WHERE painting.a_id = ? AND painting.state = states.abbrev
                 ORDER BY painting.title",
                undef, $artist_id
              );
  my @rows = Tr (th ("Title"), th ("Origin"), th ("Price"));
  foreach my $row_ref (@{$ref})
  {
    push (@rows, Tr (td ([ map { escapeHTML ($_) } @{$row_ref} ])));
  }
  $name = escapeHTML ($name);
  return @rows == 1  # array contains only header row?
         ? p ("No paintings by $name were found.")
         : p ("Paintings by $name:") . table (@rows);
}
