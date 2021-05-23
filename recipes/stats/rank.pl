#!/usr/bin/perl
# rank.pl: assign ranks to a set of values

use strict;
use warnings;
use Cookbook;

my $dbh = Cookbook::connect ();

# Create the sample table

$dbh->do ("DROP TABLE IF EXISTS t");
$dbh->do ("CREATE TABLE t (score INT)");
$dbh->do ("INSERT INTO t (score) VALUES(5),(4),(4),(3),(2),(2),(2),(1)");

# Assign ranks using position (row number) within the set of values,
# except that tied values all get the rank accorded the first of them.

my $sth = $dbh->prepare ("SELECT score FROM t ORDER BY score DESC");
$sth->execute ();
my $rownum = 0;
my $rank = 0;
my $prev_score;
print "Row\tRank\tScore\n";
while (my $ref = $sth->fetchrow_arrayref ())
{
  my $score = $ref->[0];
  ++$rownum;
  $rank = $rownum if $rownum == 1 || $prev_score != $score;
  print "$rownum\t$rank\t$score\n";
  $prev_score = $score;
}

$dbh->disconnect ();
