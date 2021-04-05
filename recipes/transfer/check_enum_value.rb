#!/usr/bin/ruby
# check_enum_value.rb: Wrapper to demonstrate check_enum_value()
# utility function that determines whether a value is a member of
# a given ENUM column.

# Usage: check_enum_value.rb db_name tbl_name col_name test_value

require "Cookbook"
require "Cookbook_Utils"

if ARGV.length != 4
  puts "Usage: check_enum_value.rb db_name tbl_name col_name test_val"
  exit(1)
end

db_name = ARGV[0]
tbl_name = ARGV[1]
col_name = ARGV[2]
val = ARGV[3]

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

valid = check_enum_value(dbh, db_name, tbl_name, col_name, val)

puts "#{val} " +
     (valid ? "is" : "is not") +
     " a member of #{tbl_name}.#{col_name}"

dbh.disconnect
