#!/usr/bin/perl
# params.pl: print input parameter names and values

use strict;
use warnings;
use CGI qw(:standard escapeHTML);

my $title = "Script Input Parameters";

print header (), start_html (-title => $title);

my @param_names;
my $id;
my @options;
my $age;

#@ _GET_PARAM_NAMES_
@param_names = param ();
#@ _GET_PARAM_NAMES_

#@ _GET_SCALAR_PARAM_
$id = param ("id");            # return scalar value
#@ _GET_SCALAR_PARAM_
#@ _GET_ARRAY_PARAM_
@options = param ("options");  # return list
#@ _GET_ARRAY_PARAM_

#@ _PROVIDE_DEFAULT_VALUE_
$age = param ("age");
$age = "unknown" if !defined ($age) || $age eq "";
#@ _PROVIDE_DEFAULT_VALUE_
print "age is $age\n";

print end_html ();
