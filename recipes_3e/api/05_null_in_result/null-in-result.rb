#!/usr/bin/ruby
# stmt.rb: demonstrate statement processing in Ruby
# (with and without placeholders)

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  exit(1)
end

begin
#@ _FETCHLOOP_
  dbh.execute("SELECT name, birth, foods FROM profile") do |sth|
    sth.fetch do |row|
      for i in 0...row.length
        row[i] = "NULL" if row[i].nil?  # is the column value NULL?
      end
      printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
    end
  end
#@ _FETCHLOOP_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

dbh.disconnect
