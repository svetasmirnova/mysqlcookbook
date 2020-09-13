#!/usr/bin/perl
# search_state.pl: Simple "search for state" application.

# Present a form with an input field and a submit button.  User enters
# a state abbreviation or a state name into the field and submits the
# form.  Script finds the abbreviation and displays the full name, or
# vice versa.

use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;

my $title = "State Name or Abbreviation Lookup";

print header (), start_html (-title => $title);

# If keyword parameter is present and nonempty, perform a lookup.

my $keyword = param ("keyword");

if (defined ($keyword) && $keyword !~ /^\s*$/)
{
  my $dbh = Cookbook::connect ();
  my $found = 0;
  my $s;

  # first look for keyword as a state abbreviation;
  # if that fails, look for it as a name
  $s = $dbh->selectrow_array ("SELECT name FROM states WHERE abbrev = ?",
                              undef, $keyword);
  if ($s)
  {
    ++$found;
    print p ("You entered the abbreviation: " . escapeHTML ($keyword));
    print p ("The corresponding state name is : " . escapeHTML ($s));
  }
  $s = $dbh->selectrow_array ("SELECT abbrev FROM states WHERE name = ?",
                              undef, $keyword);
  if ($s)
  {
    ++$found;
    print p ("You entered the state name: " . escapeHTML ($keyword));
    print p ("The corresponding abbreviation is : " . escapeHTML ($s));
  }
  if (!$found)
  {
    print p ("You entered the keyword: " . escapeHTML ($keyword));
    print p ("No match was found.");
  }

  $dbh->disconnect ();
}

print p (qq{
Enter a state name into the form and select Search, and I will
show you the corresponding abbreviation. Or enter an abbreviation
and I will show you the full name.
});

print start_form (-action => url ()),
      "State: ",
      textfield (-name => "keyword", -size => 20),
      br (),
      submit (-name => "choice", -value => "Search"),
      end_form ();

print end_html ();
