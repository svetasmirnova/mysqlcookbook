#!/usr/bin/ruby
# get_column_info.rb: wrapper to demonstrate get_column_info()
# utility routine

# Assumes that you've created the "image" table!

require "Cookbook"
require "Cookbook_Utils"

db_name = "cookbook"
tbl_name = "image"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Using get_column_info()"
puts "Column information for #{db_name}.#{tbl_name} table:"
info = get_column_info(dbh, db_name, tbl_name)
info.each do |col_name, col_info|
  puts "  Column: #{col_name}"
  col_info.each do |col_val_key, col_val|
    puts "    #{col_val_key}: #{col_val}"
  end
end

dbh.disconnect
