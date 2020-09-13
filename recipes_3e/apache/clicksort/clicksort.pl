#!/usr/bin/perl
# clicksort.pl: display query result as HTML table with "click to sort"
# column headings

# Rows from the database table are displayed as an HTML table.
# Column headings are presented as hyperlinks that reinvoke the
# script to redisplay the table sorted by the corresponding column.
# The display is limited to 50 rows in case the table is large.

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

#@ _MAIN_PROGRAM_
my $title = "Table Display with Click-To-Sort Column Headings";

# names for database and table and default sort column; change as desired
my $db_name = "cookbook";
my $tbl_name = "driver_log";

print header (), start_html (-title => $title);

my $sort_col = param ("sort");    # column name to sort by (optional)

my $dbh = Cookbook::connect ();

# Set $check_show_column nonzero to use INFORMATION_SCHEMA verification of
# the sort column name; otherwise a simple lexical test is performed.

my $check_show_columns = 0;

if (!defined ($sort_col))
{
  $sort_col = $dbh->selectrow_array (
               "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
                AND ORDINAL_POSITION = 1",
               undef, $db_name, $tbl_name);
  error ("Cannot determine first column of $db_name.$tbl_name")
    unless $sort_col;
}
else
{
  if ($check_show_columns)
  {
    # make sure sort column is in the table
    my $exists = $dbh->selectrow_array (
                   "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
                    AND COLUMN_NAME = ?",
                   undef, $db_name, $tbl_name, $sort_col);
    error ("$sort_col: not a column in $db_name.$tbl_name")
      unless $exists;
  }
  else
  {
    if ($sort_col !~ /^[0-9a-zA-Z_]+$/)
    {
      error ("Column name $sort_col is invalid");
    }
  }
}

# Construct query to select records from the table, sorting by the
# named column. Limit output to 50 rows to avoid dumping entire
# contents of large tables.

my $stmt = sprintf ("SELECT * FROM %s.%s ORDER BY %s LIMIT 50",
                    $dbh->quote_identifier ($db_name),
                    $dbh->quote_identifier ($tbl_name),
                    $dbh->quote_identifier ($sort_col));
my $sth = $dbh->prepare ($stmt);
$sth->execute ();

# Display query results as HTML table.  Use query metadata to get column
# names, and display names in first row of table as hyperlinks that cause
# the table to be redisplayed, sorted by the corresponding table column.

my @rows;
my @cells;

for (my $i = 0; $i < $sth->{NUM_OF_FIELDS}; $i++)
{
  my $col_name = $sth->{NAME}->[$i];
  my $url = sprintf ("%s?sort=%s", url (), escape ($col_name));
  push (@cells, a ({-href => $url}, escapeHTML ($col_name)));
}
push (@rows, th (\@cells));

while (my @val = $sth->fetchrow_array ())
{
  # encode cell values, avoiding warnings for undefined
  # values and using &nbsp; for empty cells
  @val = map {
           defined ($_) && $_ !~ /^\s*$/ ? escapeHTML ($_) : "&nbsp;"
         } @val;
  push (@rows, td (\@val));
}

$dbh->disconnect ();

print p (escapeHTML ("Table: $db_name.$tbl_name"));
print p ("Click a column name to sort by that column.");

print table ({-border => 1}, Tr (\@rows));
print end_html ();
#@ _MAIN_PROGRAM_

sub error
{
my $msg = shift;

  print p (escapeHTML ($msg)), end_html ();
  exit (0);
}

# this shows how to construct the table header row using a single
# way-too-complicated statement

if (0)
{
my ($tbl, @cells);
#@ _HEADER_SINGLE_STATEMENT_
push (@cells, map { a ({-href =>
                        url () . sprintf ("?tbl=%s&sort=%s",
                              escape ($tbl), escape ($_))},
                        escapeHTML ($_))
                  } @{$sth->{NAME}});
#@ _HEADER_SINGLE_STATEMENT_
}
