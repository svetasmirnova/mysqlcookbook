#!/usr/bin/ruby
# high_level.rb: demonstrate higher-level retrieval methods in Ruby
# (without placeholders)

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  exit(1)
end

puts "Fetch single row using select_one"
begin
#@ _SELECT_ONE_
  row = dbh.select_one("SELECT id, name, cats FROM profile WHERE id = 3")
#@ _SELECT_ONE_
  printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch all rows using select_all"
begin
#@ _SELECT_ALL_NO_ITERATOR_
  rows = dbh.select_all( "SELECT id, name, cats FROM profile")
#@ _SELECT_ALL_NO_ITERATOR_
  rows.each do |row|
    printf "id: %s, name: %s, cats: %s\n",
           row["id"], row["name"], row["cats"]
  end
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch all rows, applying iterator directly to select_all"
begin
#@ _SELECT_ALL_ITERATOR_
  dbh.select_all("SELECT id, name, cats FROM profile").each do |row|
    printf "id: %s, name: %s, cats: %s\n",
           row["id"], row["name"], row["cats"]
  end
#@ _SELECT_ALL_ITERATOR_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

dbh.disconnect
