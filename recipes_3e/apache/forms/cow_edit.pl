#!/usr/bin/perl
# cow_edit.pl: Present a form for editing a record in the cow_order table.
# (Display only; does not actually process submitted contents.)

# Form has fields that are initialized to the column values from a record
# in the table.  (The script uses record 1.)

use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;
use Cookbook_Utils;

my $title = "Cow Figurine Order Record Editing Form";

print header (), start_html (-title => $title);

my $dbh = Cookbook::connect ();

# Retrieve a record by ID from the cow_order table

#@ _FETCH_ORDER_INFO_
my $id = 1;     # select record number 1
my ($color, $size, $accessories,
    $cust_name, $cust_street, $cust_city, $cust_state)
      = $dbh->selectrow_array (qq{
          SELECT
             color, size, accessories,
             cust_name, cust_street, cust_city, cust_state
           FROM cow_order WHERE id = ?
        }, undef, $id);
#@ _FETCH_ORDER_INFO_
defined ($color) or die "No cow_order record for id $id was found.\n";

print p ("Values to be loaded into form:");
print ul (li (escapeHTML ("id = $id (this is a hidden field;"
                          . " use 'show source' to see it)")),
          li (escapeHTML ("color = $color")),
          li (escapeHTML ("size = $size")),
          li (escapeHTML ("accessories = $accessories")),
          li (escapeHTML ("name = $cust_name")),
          li (escapeHTML ("street = $cust_street")),
          li (escapeHTML ("city = $cust_city")),
          li (escapeHTML ("state = $cust_state")));

#@ _SPLIT_ACCESSORY_VALUE_
my @acc_val = defined ($accessories)
               ? split (/,/, $accessories)
               : ();
#@ _SPLIT_ACCESSORY_VALUE_

# Retrieve values for color list

#@ _FETCH_COLOR_LIST_
my $color_ref = $dbh->selectcol_arrayref (qq{
  SELECT color FROM cow_color ORDER BY color
});
#@ _FETCH_COLOR_LIST_

# Retrieve metadata for size and accessory columns

#@ _FETCH_SIZE_INFO_
my $size_info = get_enumorset_info ($dbh, "cookbook",
                                    "cow_order", "size");
#@ _FETCH_SIZE_INFO_
#@ _FETCH_ACCESSORY_INFO_
my $acc_info = get_enumorset_info ($dbh, "cookbook",
                                   "cow_order", "accessories");
#@ _FETCH_ACCESSORY_INFO_

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
my @state_values;
my %state_labels;
my $sth = $dbh->prepare (qq{
  SELECT abbrev, name FROM states ORDER BY name
});
$sth->execute ();
while (my ($abbrev, $name) = $sth->fetchrow_array ())
{
  push (@state_values, $abbrev);  # save each value in an array
  $state_labels{$abbrev} = $name; # map each value to its label
}
#@ _FETCH_STATE_LIST_

$dbh->disconnect ();

# Generate various types of form elements, using the cow_order record
# to provide the default value for each element.  In each case, the
# -override => 1 parameter forces the supplied value to be used, even
# if the script environment should happen to have a parameter with the
# same name.

#@ _PRINT_START_FORM_
print start_form (-action => url ());
#@ _PRINT_START_FORM_

# Put ID value into a hidden field

#@ _PRINT_ID_HIDDEN_
print hidden (-name => "id", -value => $id, -override => 1);
#@ _PRINT_ID_HIDDEN_

# Use color list to generate a pop-up menu

#@ _PRINT_COLOR_POPUP_
print br (), "Cow color:", br ();
print popup_menu (-name => "color",
                  -values => $color_ref,
                  -default => $color,
                  -override => 1);
#@ _PRINT_COLOR_POPUP_

# Use size column ENUM information to generate radio buttons

#@ _PRINT_SIZE_RADIO_
print br (), "Cow figurine size:", br ();
print radio_group (-name => "size",
                   -values => $size_info->{values},
                   -default => $size,
                   -override => 1,
                   -linebreak => 1);
#@ _PRINT_SIZE_RADIO_

# Use accessory column SET information to generate checkboxes

#@ _PRINT_ACCESSORY_CHECKBOX_
print br (), "Cow accessory items:", br ();
print checkbox_group (-name => "accessories",
                      -values => $acc_info->{values},
                      -default => \@acc_val,
                      -override => 1,
                      -linebreak => 1);
#@ _PRINT_ACCESSORY_CHECKBOX_

#@ _PRINT_CUST_NAME_TEXT_
print br (), "Customer name:", br ();
print textfield (-name => "cust_name",
                 -value => $cust_name,
                 -override => 1,
                 -size => 60);
#@ _PRINT_CUST_NAME_TEXT_

#@ _PRINT_CUST_STREET_TEXT_
print br (), "Customer street address:", br ();
print textfield (-name => "cust_street",
                 -value => $cust_street,
                 -override => 1,
                 -size => 60);
#@ _PRINT_CUST_STREET_TEXT_

#@ _PRINT_CUST_CITY_TEXT_
print br (), "Customer city:", br ();
print textfield (-name => "cust_city",
                 -value => $cust_city,
                 -override => 1,
                 -size => 60);
#@ _PRINT_CUST_CITY_TEXT_

#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_
print br (), "Customer state:", br ();
print scrolling_list (-name => "cust_state",
                      -values => \@state_values,
                      -labels => \%state_labels,
                      -default => $cust_state,
                      -override => 1,
                      -size => 6);      # display 6 items at a time
#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_

#@ _PRINT_END_FORM_
print br (),
      submit (-name => "choice", -value => "Submit Form"),
      end_form ();
#@ _PRINT_END_FORM_

print end_html ();
