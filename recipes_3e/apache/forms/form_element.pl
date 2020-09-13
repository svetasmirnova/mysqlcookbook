#!/usr/bin/perl
# form_element.pl: generate form elements from database contents

use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;
use Cookbook_Utils;

my $title = "Form Element Generation";

print header (), start_html (-title => $title);

my $dbh = Cookbook::connect ();

print start_form (-action => url (), -method => "post");

print p ("Cow color:");

# Retrieve values for color list

#@ _FETCH_COLOR_LIST_
my $color_ref = $dbh->selectcol_arrayref (qq{
  SELECT color FROM cow_color ORDER BY color
});
#@ _FETCH_COLOR_LIST_

# Use color list to generate single-pick form elements

print p ("As radio button group:");
#@ _PRINT_COLOR_RADIO_
print radio_group (-name      => "color",
                   -values    => $color_ref,
                   -linebreak => 1);      # display buttons vertically
#@ _PRINT_COLOR_RADIO_

print p ("As popup menu:");
#@ _PRINT_COLOR_POPUP_
print popup_menu (-name   => "color",
                  -values => $color_ref);
#@ _PRINT_COLOR_POPUP_

print p ("As single-pick scrolling list:");
#@ _PRINT_COLOR_SCROLLING_SINGLE_
print scrolling_list (-name   => "color",
                      -values => $color_ref,
                      -size   => 3);      # display 3 items at a time
#@ _PRINT_COLOR_SCROLLING_SINGLE_

# Add a "Please choose a color" item to head of the list

#print p ("As popup menu with initial no-choice item:");
##@ _PLEASE_CHOOSE_
# THIS DOES NOT WORK
#unshift (@color_values, "0");
#$color_labels{0} = "Please choose a color";
#print popup_menu (-name    => "color",
#                  -values  => $color_ref,
#                  -default => "0");
##@ _PLEASE_CHOOSE_

print hr ();
print p ("Cow figurine size:");

# Use ENUM column information to generate single-pick list elements

# Retrieve metadata for size columns

#@ _FETCH_SIZE_INFO_
my $size_info = get_enumorset_info ($dbh, "cookbook", "cow_order", "size");
#@ _FETCH_SIZE_INFO_

print p ("As radio button group:");
#@ _PRINT_SIZE_RADIO_
print radio_group (-name      => "size",
                   -values    => $size_info->{values},
                   -default   => $size_info->{default},
                   -linebreak => 1);   # display buttons vertically
#@ _PRINT_SIZE_RADIO_

print p ("As popup menu:");
#@ _PRINT_SIZE_POPUP_
print popup_menu (-name    => "size",
                  -values  => $size_info->{values},
                  -default => $size_info->{default});
#@ _PRINT_SIZE_POPUP_

print p ("As single-pick scrolling list:");
print p ("(skipped; too few items)");

print hr ();
print p ("Cow accessories:");

# Use SET column information to generate multiple-pick list elements

#@ _FETCH_ACCESSORY_INFO_
my $acc_info = get_enumorset_info ($dbh, "cookbook", "cow_order", "accessories");
#@ _FETCH_ACCESSORY_INFO_
#@ _SPLIT_ACCESSORY_DEFAULT_
my @acc_def = defined ($acc_info->{default})
               ? split (/,/, $acc_info->{default})
               : ();
#@ _SPLIT_ACCESSORY_DEFAULT_

print p ("As checkbox group:");
#@ _PRINT_ACCESSORY_CHECKBOX_
print checkbox_group (-name      => "accessories",
                      -values    => $acc_info->{values},
                      -default   => \@acc_def,
                      -linebreak => 1);   # display buttons vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

print p ("As multiple-pick scrolling list:");
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_
print scrolling_list (-name     => "accessories",
                      -values   => $acc_info->{values},
                      -default  => \@acc_def,
                      -size     => 3,     # display 3 items at a time
                      -multiple => 1);    # create multiple-pick list
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_

print hr ();
print p ("State of residence:");

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

# Use state list to generate single-pick form elements

print p ("As radio button group:");
print p ("(skipped; too many items)");

print p ("As popup menu:");
#@ _PRINT_STATE_POPUP_
print popup_menu (-name   => "state",
                  -values => \@state_values,
                  -labels => \%state_labels);
#@ _PRINT_STATE_POPUP_

print p ("As single-pick scrolling list:");
#@ _PRINT_STATE_SCROLLING_SINGLE_
print scrolling_list (-name   => "state",
                      -values => \@state_values,
                      -labels => \%state_labels,
                      -size   => 6);      # display 6 items at a time
#@ _PRINT_STATE_SCROLLING_SINGLE_

print hr ();
print p ("Tables in cookbook database:");
#@ _TABLE_SCROLLING_SINGLE_
my $table_ref = $dbh->selectcol_arrayref (qq{
  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME
});
print scrolling_list (-name   => "table",
                      -values => $table_ref,
                      -size   => 10);     # display 10 items at a time
#@ _TABLE_SCROLLING_SINGLE_

print end_form ();
print end_html ();

$dbh->disconnect ();
