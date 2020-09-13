#!/usr/bin/perl
# lists.pl: generate HTML lists

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "Query Output Display - Lists";

print header (), start_html (-title => $title);

my $dbh = Cookbook::connect ();

{ # begin scope

print p ("Ordered list:");

#@ _ORDERED_LIST_INTERTWINED_
my $stmt = "SELECT item FROM ingredient ORDER BY id";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
my @items;
while (my $ref = $sth->fetchrow_arrayref ())
{
  # handle possibility of NULL (undef) item
  my $item = defined ($ref->[0]) ? escapeHTML ($ref->[0]) : "";
  push (@items, li ($item));
}
print ol (@items);
#@ _ORDERED_LIST_INTERTWINED_

} # end scope

{ # begin scope

print p ("Ordered list:");

#@ _ORDERED_LIST_DECOUPLED_
# fetch items for list
my $stmt = "SELECT item FROM ingredient ORDER BY id";
my $item_ref = $dbh->selectcol_arrayref ($stmt);

# generate HTML list, handling possibility of NULL (undef) items
$item_ref = [ map { defined ($_) ? escapeHTML ($_) : "" } @{$item_ref} ];
print ol (li ($item_ref));
#@ _ORDERED_LIST_DECOUPLED_

} # end scope

{ # begin scope

print p ("Unordered list:");

#@ _UNORDERED_LIST_INTERTWINED_
my $stmt = "SELECT item FROM ingredient ORDER BY id";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
my @items;
while (my $ref = $sth->fetchrow_arrayref ())
{
  # handle possibility of NULL (undef) item
  my $item = defined ($ref->[0]) ? escapeHTML ($ref->[0]) : "";
  push (@items, li ($item));
}
print ul (@items);
#@ _UNORDERED_LIST_INTERTWINED_

} # end scope

{ # begin scope

print p ("Unordered list:");

#@ _UNORDERED_LIST_DECOUPLED_
# fetch items for list
my $stmt = "SELECT item FROM ingredient ORDER BY id";
my $item_ref = $dbh->selectcol_arrayref ($stmt);

# generate HTML list, handling possibility of NULL (undef) items
$item_ref = [ map { defined ($_) ? escapeHTML ($_) : "" } @{$item_ref} ];
print ul (li ($item_ref));
#@ _UNORDERED_LIST_DECOUPLED_

} # end scope

{ # begin scope

print p ("Unmarked list:");

my $stmt = "SELECT item FROM ingredient ORDER BY id";
my $item_ref = $dbh->selectcol_arrayref ($stmt);
my @items = @{$item_ref};
#@ _UNMARKED_LIST_DECOUPLED_
foreach my $item (@items)
{
  # handle possibility of NULL (undef) values
  $item = defined ($item) ? escapeHTML ($item) : "";
  print $item . br ();
}
#@ _UNMARKED_LIST_DECOUPLED_

} # end scope

{ # begin scope

print p ("Definition list:\n");

#@ _DEFINITION_LIST_INTERTWINED_1_
my $stmt = "SELECT note, mnemonic FROM doremi ORDER BY id";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
my @items;
while (my ($note, $mnemonic) = $sth->fetchrow_array ())
{
  # handle possibility of NULL (undef) values
  $note = defined ($note) ? escapeHTML ($note) : "";
  $mnemonic = defined ($mnemonic) ? escapeHTML ($mnemonic) : "";
  push (@items, dt ($note));
  push (@items, dd ($mnemonic));
}
print dl (@items);
#@ _DEFINITION_LIST_INTERTWINED_1_

} # end scope

{ # begin scope

print p ("Definition list:\n");

#@ _DEFINITION_LIST_INTERTWINED_2_
# count number of tables per database
my $sth = $dbh->prepare ("SELECT TABLE_SCHEMA, COUNT(TABLE_NAME)
                          FROM INFORMATION_SCHEMA.TABLES
                          GROUP BY TABLE_SCHEMA");
$sth->execute ();
my @items;
while (my ($db_name, $tbl_count) = $sth->fetchrow_array ())
{
  push (@items, dt (escapeHTML ($db_name)));
  push (@items, dd (escapeHTML ($tbl_count . " tables")));
}
print dl (@items);
#@ _DEFINITION_LIST_INTERTWINED_2_

} # end scope

# Nested list, three implementations:
# - 1 query to get n distinct years, n queries to get states for each year;
#   data collection intertwined with HTML generation
# - 1 query to get all information;
#   data collection intertwined with HTML generation
# - 1 query to get all information
#   data collection separate from HTML generation

print p ("Definition list w/nested unordered lists:\n");

{ # begin scope

print p ("Method 1:");

#@ _NESTED_LISTS_1_
# get list of initial letters
my $ltr_ref = $dbh->selectcol_arrayref (
                  "SELECT DISTINCT UPPER(LEFT(name,1)) AS letter
                   FROM states ORDER BY letter");
my @items;
# get list of states for each letter
foreach my $ltr (@{$ltr_ref})
{
  my $item_ref = $dbh->selectcol_arrayref (
                    "SELECT name FROM states WHERE LEFT(name,1) = ?
                     ORDER BY name", undef, $ltr);
  $item_ref = [ map { escapeHTML ($_) } @{$item_ref} ];
  # convert list of states to unordered list
  my $item_list = ul (li ($item_ref));
  # for each definition list item, the initial letter is
  # the term, and the list of states is the definition
  push (@items, dt ($ltr));
  push (@items, dd ($item_list));
}
print dl (@items);
#@ _NESTED_LISTS_1_

} # end scope

{ # begin scope

print p ("Method 2:");

#@ _NESTED_LISTS_2_
my $sth = $dbh->prepare ("SELECT name FROM states ORDER BY name");
$sth->execute ();
my @items;
my @names;
my $cur_ltr = "";
while (my ($name) = $sth->fetchrow_array ())
{
  my $ltr = uc (substr ($name, 0, 1));  # initial letter of name
  if ($cur_ltr ne $ltr)                 # beginning a new letter?
  {
    if (@names)       # any stored-up names from previous letter?
    {
      # for each definition list item, the initial letter is
      # the term, and the list of states is the definition
      push (@items, dt ($cur_ltr));
      push (@items, dd (ul (li (\@names))));
    }
    @names = ();
    $cur_ltr = $ltr;
  }
  push (@names, escapeHTML ($name));
}
if (@names)           # any remaining names from final letter?
{
  push (@items, dt ($cur_ltr));
  push (@items, dd (ul (li (\@names))));
}
print dl (@items);
#@ _NESTED_LISTS_2_

} # end scope

{ # begin scope

print p ("Method 3:");

#@ _NESTED_LISTS_3_
# collect state names and associate each with the proper
# initial-letter list
my $sth = $dbh->prepare ("SELECT name FROM states ORDER BY name");
$sth->execute ();
my %ltr;
while (my ($name) = $sth->fetchrow_array ())
{
  my $ltr = uc (substr ($name, 0, 1));  # initial letter of name
  # initialize letter list to empty array if this is
  # first state for it, then add state to array
  $ltr{$ltr} = [] unless exists ($ltr{$ltr});
  push (@{$ltr{$ltr}}, $name);
}

# generate the output lists
my @items;
foreach my $ltr (sort (keys (%ltr)))
{
  # encode list of state names for this letter, generate unordered list
  my $ul_str = ul (li ([ map { escapeHTML ($_) } @{$ltr{$ltr}} ]));
  push (@items, dt ($ltr), dd ($ul_str));
}
print dl (@items);
#@ _NESTED_LISTS_3_

} # end scope

$dbh->disconnect ();

print end_html ();
