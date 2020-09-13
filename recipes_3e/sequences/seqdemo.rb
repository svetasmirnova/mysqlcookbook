#!/usr/bin/ruby
# seqdiag.rb: test AUTO_INCREMENT operations

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  exit(1)
end

#@ _CLIENT_SIDE_FAILURE_
dbh.do("SET @x = LAST_INSERT_ID(48)")
seq = dbh.func(:insert_id)
#@ _CLIENT_SIDE_FAILURE_
puts "seq after SET via insert_id: #{seq}"
#@ _CLIENT_SIDE_SUCCESS_
seq = dbh.select_one("SELECT LAST_INSERT_ID()")[0]
#@ _CLIENT_SIDE_SUCCESS_
puts "seq after SET via LAST_INSERT_ID(): #{seq}"

dbh.disconnect
