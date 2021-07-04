#!/usr/bin/ruby
# get_enumorset_info.rb: wrapper to demonstrate get_enumorset_info()
# utility routine.

# Usage: get_enumorset_info.rb db_name tbl_name col_name

require "Cookbook"
require "Cookbook_Utils"

if ARGV.length != 3
  puts "Usage: get_enumorset_info.rb db_name tbl_name col_name"
  exit(1)
end

db_name = ARGV[0]
tbl_name = ARGV[1]
col_name = ARGV[2]

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

#@ _USE_FUNCTION_
info = get_enumorset_info(dbh, db_name, tbl_name, col_name)
puts "Information for #{db_name}.#{tbl_name}.#{col_name}:"
if info.nil?
  puts "No information available (not an ENUM or SET column?)"
else
  puts "Name: " + info["name"]
  puts "Type: " + info["type"]
  puts "Legal values: " + info["values"].join(",")
  puts "Nullable: " + (info["nullable"] ? "yes" : "no")
  puts "Default value: " + (info["default"].nil? ? "NULL" : info["default"])
end
#@ _USE_FUNCTION_

dbh.disconnect
