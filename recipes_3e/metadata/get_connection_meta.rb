#!/usr/bin/ruby
# get_connection_meta.rb: get connection metadata

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

#@ _CURRENT_DATABASE_
db = dbh.select_one("SELECT DATABASE()")[0]
puts "Default database: " + (db.nil? ? "(no database selected)" : db)
#@ _CURRENT_DATABASE_

dbh.disconnect
