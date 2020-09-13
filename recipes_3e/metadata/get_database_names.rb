#!/usr/bin/ruby
# get_database_names.rb: list names of databases on server

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Get database names from INFORMATION_SCHEMA:"
stmt = "SELECT SCHEMA_NAME
        FROM INFORMATION_SCHEMA.SCHEMATA
        ORDER BY SCHEMA_NAME"
dbh.execute(stmt) do |sth|
  sth.each do |row|
    puts row[0]
  end
end

dbh.disconnect
