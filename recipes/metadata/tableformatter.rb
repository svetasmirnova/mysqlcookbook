#!/usr/bin/ruby
# tableformatter.rb: demonstrate DBI::Utils::TableFormatter.ascii method

require "Cookbook"

stmt = "SELECT id, name, birth FROM profile"
# override statement with command line argument if one was given
stmt = ARGV[0] if ARGV.length > 0

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

#@ _TABLEFORMATTER_
dbh.execute(stmt) do |sth|
  DBI::Utils::TableFormatter.ascii(sth.column_names, sth.fetch_all)
end
#@ _TABLEFORMATTER_

dbh.disconnect
