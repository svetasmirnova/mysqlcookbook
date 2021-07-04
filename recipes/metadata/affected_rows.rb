#!/usr/bin/ruby
# affected_rows.rb

require "Cookbook"

stmt = "UPDATE profile SET cats = cats+1 WHERE name = 'Sybil'"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

# execute statement using do
#@ _FRAG_1_
count = dbh.do(stmt)
puts "Number of rows affected: #{count}"
#@ _FRAG_1_

# execute statement using prepare plus execute
#@ _FRAG_2_
sth = dbh.execute(stmt)
puts "Number of rows affected: #{sth.rows}"
#@ _FRAG_2_

dbh.disconnect

# illustrate use of mysql_client_found_rows
#@ _MYSQL_CLIENT_FOUND_ROWS_
dsn = "DBI:Mysql:database=cookbook;host=localhost;mysql_client_found_rows=1"
dbh = DBI.connect(dsn, "cbuser", "cbpass")
#@ _MYSQL_CLIENT_FOUND_ROWS_

# this statement changes no rows, but the row count should still
# be nonzero due to the use of mysql_client_found_rows
stmt = "UPDATE limbs SET arms = 0 WHERE arms = 0"
count = dbh.do(stmt)
puts "Number of rows affected: #{count}"
