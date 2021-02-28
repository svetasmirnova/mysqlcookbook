#!/usr/bin/ruby
# add_insect.rb: demonstrate client-side insert_id attribute
# for getting the most recent AUTO_INCREMENT value.

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  exit(1)
end

# Show how to generate an AUTO_INCREMENT value and retrieve it using
# the database handle.

#@ _INSERT_ID_
dbh.do("INSERT INTO insect (name,date,origin)
        VALUES('moth','2014-09-14','windowsill')")
seq = dbh.func(:insert_id)
#@ _INSERT_ID_
puts "seq: #{seq}"

dbh.disconnect
