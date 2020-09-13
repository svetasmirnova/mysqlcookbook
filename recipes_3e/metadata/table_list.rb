#!/usr/bin/ruby
# table_list.rb

# Demonstrate tables method, which returns a list of the tables
# in the current database.

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

#@ _TABLES_
tables = dbh.tables
#@ _TABLES_

puts "Tables in current database:"
puts tables.join("\n")

dbh.disconnect
