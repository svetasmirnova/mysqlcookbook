#!/usr/bin/ruby
# option_file.rb: demonstrate DSN options for reading MySQL option files

require "dbi"

begin
#@ _FRAG1_
  # basic DSN
  dsn = "DBI:Mysql:database=cookbook"
  # look in user-specific option file owned by the current user
  dsn << ";mysql_read_default_file=#{ENV['HOME']}/.my.cnf"
  dbh = DBI.connect(dsn, nil, nil)
#@ _FRAG1_
  puts "Connected"
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
else
  dbh.disconnect()
  puts "Disconnected"
end

begin
#@ _FRAG2_
  # basic DSN
  dsn = "DBI:Mysql:database=cookbook"
  # look in standard option files; use [cookbook] and [client] groups
  dsn << ";mysql_read_default_group=cookbook"
  dbh = DBI.connect(dsn, nil, nil)
#@ _FRAG2_
  puts "Connected"
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
else
  dbh.disconnect()
  puts "Disconnected"
end
