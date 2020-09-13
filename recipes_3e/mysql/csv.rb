#!/usr/bin/ruby
# csv.rb: convert tab-delimited input to comma-separated values output
while gets() do         # read next input line
  $_.gsub!(/"/,'""')    # double quotes within column values
  $_.gsub!(/\t/,'","')  # put `","' between column values
  $_.sub!(/\A/,'"')     # add `"' before the first value
  $_.sub!(/\Z/,'"')     # add `"' after the last value
  print                 # print the result
end
