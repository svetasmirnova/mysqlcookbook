#!/usr/bin/ruby
# stmt.rb: demonstrate statement processing in Ruby
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

puts "Fetch using fetch calls in a loop"
begin
#@ _FETCHLOOP_FETCH_WHILE_
  count = 0
  sth = dbh.execute("SELECT id, name, cats FROM profile")
  while row = sth.fetch do
    printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
    count += 1
  end
  sth.finish
  puts "Number of rows returned: #{count}"
#@ _FETCHLOOP_FETCH_WHILE_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using fetch as iterator (access columns by position)"
begin
  sth = dbh.execute("SELECT id, name, cats FROM profile")
#@ _FETCHLOOP_FETCH_ITERATOR_
  sth.fetch do |row|
    printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
  end
  sth.finish
#@ _FETCHLOOP_FETCH_ITERATOR_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using each as iterator"
begin
#@ _FETCHLOOP_EACH_ITERATOR_
  sth = dbh.execute("SELECT id, name, cats FROM profile")
  sth.each do |row|
    printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
  end
  sth.finish
#@ _FETCHLOOP_EACH_ITERATOR_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using fetch as iterator (access columns by name)"
begin
  sth = dbh.execute("SELECT id, name, cats FROM profile")
#@ _ACCESS_BY_NAME_
  sth.fetch do |row|
    printf "id: %s, name: %s, cats: %s\n",
           row["id"], row["name"], row["cats"]
  end
  sth.finish
#@ _ACCESS_BY_NAME_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using fetch_all"
begin
#@ _FETCH_ALL_
  sth = dbh.execute("SELECT id, name, cats FROM profile")
  rows = sth.fetch_all
  sth.finish
  rows.each do |row|
    printf "id: %s, name: %s, cats: %s\n",
           row["id"], row["name"], row["cats"]
  end
#@ _FETCH_ALL_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using execute as iterator (access columns by position)"
begin
#@ _FETCHLOOP_EXECUTE_ITERATOR_
  dbh.execute("SELECT id, name, cats FROM profile") do |sth|
    sth.fetch do |row|
      printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
    end
  end
#@ _FETCHLOOP_EXECUTE_ITERATOR_
  puts "Number of rows returned: #{count}"
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch, accessing row values using each_with_name iterator"
begin
  sth = dbh.execute("SELECT id, name, cats FROM profile")
  sth.each do |row|
    row.each_with_name do |val, name|
      printf "%s: %s, ", name, val.to_s
    end
    print "\n"
  end
  sth.finish
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using fetch_array as iterator"
begin
  sth = dbh.execute("SELECT id, name, cats FROM profile")
  sth.fetch_array do |row|
    printf "id: %s, name: %s, cats: %s\n", row[0], row[1], row[2]
  end
  sth.finish
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using fetch_hash calls in a loop"
begin
#@ _FETCHLOOP_FETCH_HASH_WHILE_
  sth = dbh.execute("SELECT id, name, cats FROM profile")
  while row = sth.fetch_hash do
    printf "id: %s, name: %s, cats: %s\n",
           row["id"], row["name"], row["cats"]
  end
  sth.finish
#@ _FETCHLOOP_FETCH_HASH_WHILE_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Fetch using fetch_hash as iterator"
begin
  sth = dbh.execute("SELECT id, name, cats FROM profile")
#@ _FETCHLOOP_FETCH_HASH_ITERATOR_
  sth.fetch_hash do |row|
    printf "id: %s, name: %s, cats: %s\n",
           row["id"], row["name"], row["cats"]
  end
  sth.finish
#@ _FETCHLOOP_FETCH_HASH_ITERATOR_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Execute UPDATE statement"
begin
#@ _DO_1_
  count = dbh.do("UPDATE profile SET cats = cats+1 WHERE name = 'Sybil'")
  puts "Number of rows updated: #{count}"
#@ _DO_1_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

dbh.disconnect
