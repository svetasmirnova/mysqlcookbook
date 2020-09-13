#!/usr/bin/perl

use strict;
use warnings;
my $str = "<>&\" ';?";
print "string to be encoded: $str\n";

eval
{
print "escape(), escapeHTML() as CGI object methods:\n";
#@ _METHOD_1_
use CGI;
my $cgi = new CGI;
printf "%s\n%s\n", $cgi->escape ($str), $cgi->escapeHTML ($str);
#@ _METHOD_1_
};
print "$@\n" if $@;

eval
{
print "escape(), escapeHTML() as CGI class methods:\n";
#@ _METHOD_2_
use CGI;
printf "%s\n%s\n", CGI::escape ($str), CGI::escapeHTML ($str);
#@ _METHOD_2_
};
print "$@\n" if $@;

eval
{
print "escape(), escapeHTML() as functions:\n";
#@ _METHOD_3_
#@ _USE_
use CGI qw(:standard escape escapeHTML);
#@ _USE_
printf "%s\n%s\n", escape ($str), escapeHTML ($str);
#@ _METHOD_3_
};
print "$@\n" if $@;
