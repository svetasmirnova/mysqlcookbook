#!/usr/bin/ruby
# distinct_col.rb: resolve ambiguous join output column names using aliases

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end


# First demonstrate the problem using a query that returns nonunique
# column names.

#@ _FRAG_1_
stmt = "
  SELECT artist.name, painting.title, states.name, painting.price
  FROM artist INNER JOIN painting INNER JOIN states
  ON artist.a_id = painting.a_id AND painting.state = states.abbrev
"
sth = dbh.execute(stmt)
# Determine the number of columns in result set rows two ways:
# - Check sth.column_names.size
# - Fetch a row into a hash and see how many keys the hash contains
count1 = sth.column_names.size
row = sth.fetch_hash
count2 = row.keys.size
puts "The statement is: #{stmt}"
puts "According to column_names_size, the result set has #{count1} columns"
puts "The column names are: " +
      sth.column_info.collect { |info| info["name"] }.sort.join(",")
puts "According to the row hash size, the result set has #{count2} columns"
puts "The column names are: " + row.keys.sort.join(",")
#@ _FRAG_1_
puts "The counts DO NOT match!" if count1 != count2
sth.finish

puts ""

# Assign column aliases to provide distinct names

#@ _FRAG_2_
stmt = "
  SELECT
    artist.name AS painter, painting.title,
    states.name AS state, painting.price
  FROM artist INNER JOIN painting INNER JOIN states
  ON artist.a_id = painting.a_id AND painting.state = states.abbrev
"
sth = dbh.execute(stmt)
# Determine the number of columns in result set rows two ways:
# - Check sth.column_names.size
# - Fetch a row into a hash and see how many keys the hash contains
count1 = sth.column_names.size
row = sth.fetch_hash
count2 = row.keys.size
puts "The statement is: #{stmt}"
puts "According to column_names_size, the result set has #{count1} columns"
puts "The column names are: " +
      sth.column_info.collect { |info| info["name"] }.sort.join(",")
puts "According to the row hash size, the result set has #{count2} columns"
puts "The column names are: " + row.keys.sort.join(",")
#@ _FRAG_2_
puts "The counts DO NOT match!" if count1 != count2
sth.finish

dbh.disconnect
