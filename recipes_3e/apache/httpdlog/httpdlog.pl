#!/usr/bin/perl
# httpdlog.pl: Log Apache requests to httpdlog table

# path to directory containing Cookbook.pm (*** CHANGE AS NECESSARY ***)
use lib qw(/usr/local/lib/mcb);
use strict;
use warnings;
use Cookbook;

my $dbh = Cookbook::connect ();
my $sth = $dbh->prepare (qq{
            INSERT INTO httpdlog
              (dt,host,method,url,status,size,referer,agent)
              VALUES (?,?,?,?,?,?,?,?)
          });

while (<>)  # loop while there is input to read
{
  chomp;
  my ($dt, $host, $method, $url, $status, $size, $refer, $agent)
    = split (/\t/, $_);
  # map "-" to NULL for some columns
  $size = undef if $size eq "-";
  $agent = undef if $agent eq "-";
  $sth->execute ($dt, $host, $method, $url,
                 $status, $size, $refer, $agent);
}

$dbh->disconnect ();
