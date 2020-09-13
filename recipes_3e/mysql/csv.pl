#!/usr/bin/perl
# csv.pl: convert tab-delimited input to comma-separated values output
while (<>)        # read next input line
{
  s/"/""/g;       # double quotes within column values
  s/\t/","/g;     # put "," between column values
  s/^/"/;         # add " before the first value
  s/$/"/;         # add " after the last value
  print;          # print the result
}
