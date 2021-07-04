#!/usr/bin/ruby
# get_server_version.rb: get server version string and number from server

# This script demonstrates how to get the string by issuing a
# SELECT VERSION() statement.

require "Cookbook"

# Return an array consisting of the server version number in both string
# and numeric forms.

def get_server_version(dbh)
  # fetch result into scalar string
  ver_str = dbh.select_one("SELECT VERSION()")[0]
  major, minor, teeny = ver_str.split(/\./)
  teeny.sub!(/\D.*$/, "")  # strip nonnumeric suffix if present
  ver_num = major.to_i*10000 + minor.to_i*100 + teeny.to_i
  [ver_str, ver_num]
end

begin
  dbh = Cookbook.connect
  # get server version string and number and print them
  ver_str, ver_num = get_server_version(dbh)
  puts "Version: #{ver_str} (#{ver_num})"
  dbh.disconnect
rescue DBI::DatabaseError => e
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end
