#!/usr/bin/perl
# links.pl: generate HTML hyperlinks

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;
use Cookbook_Webutils;

my $title = "Query Output Display - Hyperlinks";

print header (), start_html (-title => $title);

my $dbh = Cookbook::connect ();

{ # begin scope

print p ("Book vendors as static text:\n");
#@ _DISPLAY_STATIC_URL_
my $stmt = "SELECT name, website FROM book_vendor ORDER BY name";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
my @items;
while (my @row = $sth->fetchrow_array ())
{
  push (@items, escapeHTML ("Vendor: $row[0], website: http://$row[1]"));
}
print ul (li (\@items));
#@ _DISPLAY_STATIC_URL_

} # end scope

{ # begin scope

print p ("Book vendors as hyperlinks:\n");
#@ _DISPLAY_HYPERLINK_URL_
my $stmt = "SELECT name, website FROM book_vendor ORDER BY name";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
my @items;
while (my ($name, $website) = $sth->fetchrow_array ())
{
  push (@items, a ({-href => "http://$website"}, escapeHTML ($name)));
}
print ul (li (\@items));
#@ _DISPLAY_HYPERLINK_URL_

} # end scope

{ # begin scope

print p ("Email directory:\n");
#@ _DISPLAY_EMAIL_LIST_
my $stmt = "SELECT department, name, email FROM newsstaff
            ORDER BY department, name";
my $sth = $dbh->prepare ($stmt);
$sth->execute ();
my @items;
while (my ($dept, $name, $email) = $sth->fetchrow_array ())
{
  push (@items,
        escapeHTML ($dept) . ": " . make_email_link ($name, $email));
}
print ul (li (\@items));
#@ _DISPLAY_EMAIL_LIST_

} # end scope

print p ("Some sample invocations of make_email_link():\n");
print p ("Name + address: "
      . make_email_link ("Rex Conex", "rconex\@wrrr-news.com"));
print p ("Name + undef address: "
      . make_email_link ("Rex Conex", undef));
print p ("Name + empty string address: "
      . make_email_link ("Rex Conex", ""));
print p ("Name + missing address: "
      . make_email_link ("Rex Conex"));
print p ("Address as name: "
      . make_email_link ("rconex\@wrrr-news.com", "rconex\@wrrr-news.com"));

$dbh->disconnect ();

print end_html ();
