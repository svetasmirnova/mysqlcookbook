#!/usr/bin/ruby
# database_exists.rb

# Test for database existence.  Name one or more db's on the command line.

require "Cookbook"

# Test whether a database exists.

# Caveat: database_exists() returns false if the database exists
# but you don't have privileges for accessing it.

#@ _DATABASE_EXISTS_
def database_exists(dbh, db_name)
  return !dbh.select_one("SELECT SCHEMA_NAME
                          FROM INFORMATION_SCHEMA.SCHEMATA
                          WHERE SCHEMA_NAME = ?", db_name).nil?
end
#@ _DATABASE_EXISTS_

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

if ARGV.length == 0
  puts "Usage: database_exists.rb db_name ..."
  exit(1)
end

ARGV.each do |db_name|
  puts "#{db_name}: " +
    (database_exists(dbh, db_name) ? "exists" : "does not exist")
end

dbh.disconnect

