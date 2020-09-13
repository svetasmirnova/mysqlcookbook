#!/usr/bin/ruby
# table_exists.rb

# Test for table existence.  Name a database and one or more
# tables on the command line.

require "Cookbook"

# Test whether a table exists.

# Caveat: table_exists() returns false if the table exists but you
# don't have privileges for accessing it.

#@ _TABLE_EXISTS_
def table_exists(dbh, db_name, tbl_name)
  return !dbh.select_one("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
                          WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?",
                         db_name, tbl_name).nil?
end
#@ _TABLE_EXISTS_

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

if ARGV.length < 2
  puts "Usage: table_exists.rb db_name tbl_name ..."
  exit(1)
end

db_name = ARGV.shift

ARGV.each do |tbl_name|
  puts "#{tbl_name}: " +
    (table_exists(dbh, db_name, tbl_name) ? "exists" : "does not exist")
end

dbh.disconnect
