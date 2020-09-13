#!/usr/bin/ruby
# error.rb: demonstrate MySQL error handling

require "dbi"

#@ _FRAG_
begin
  dsn = "DBI:Mysql:host=localhost;database=cookbook"
  dbh = DBI.connect(dsn, "baduser", "badpass")
  puts "Connected"
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  puts "Error SQLSTATE: #{e.state}"
  exit(1)
end
#@ _FRAG_
dbh.disconnect
puts "Disconnected"
