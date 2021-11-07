#!/usr/bin/ruby
# connect.rb: connect to the MySQL server

require "dbi"

begin
  dsn = "DBI:Mysql:host=localhost;database=cookbook"
  dbh = DBI.connect(dsn, "cbuser", "cbpass")
  puts "Connected"
rescue => e
  puts "Cannot connect to server"
puts e.backtrace
  exit(1)
end
dbh.disconnect
puts "Disconnected"
