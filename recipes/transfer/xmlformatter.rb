#!/usr/bin/ruby
# xmlformatter.rb: Demonstrate DBI::Utils::XMLFormatter.table method.

require "Cookbook"

stmt = "SELECT * FROM expt"
# override statement with command line argument if one was given
stmt = ARGV[0] if ARGV.length > 0

dbh = Cookbook.connect
DBI::Utils::XMLFormatter.table(dbh.select_all(stmt))
dbh.disconnect
