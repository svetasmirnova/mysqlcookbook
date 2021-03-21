#!/usr/bin/ruby
# placeholder.rb: demonstrate statement processing in Ruby
# (with placeholders)

require "Cookbook"

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  exit(1)
end

# Pass data values directly to do()

puts "Execute INSERT statement with do()"
begin
#@ _PLACEHOLDER_DO_
  count = dbh.do("INSERT INTO profile (name,birth,color,foods,cats)
                  VALUES(?,?,?,?,?)",
                 "De'Mont", "1973-01-12", nil, "eggroll", 4)
#@ _PLACEHOLDER_DO_
  puts "Number of rows inserted: #{count}"
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

# Prepare a statement, then pass the statement and data values to execute()

puts "Execute INSERT statement with prepare() + execute()"
begin
#@ _PLACEHOLDER_PREPARE_EXECUTE_1_
  sth = dbh.prepare("INSERT INTO profile (name,birth,color,foods,cats)
                     VALUES(?,?,?,?,?)")
  count = sth.execute("De'Mont", "1973-01-12", nil, "eggroll", 4)
#@ _PLACEHOLDER_PREPARE_EXECUTE_1_
  puts "Number of rows inserted: #{count}"
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Execute SELECT statement with placeholder"
begin
#@ _PLACEHOLDER_PREPARE_EXECUTE_2_
  sth = dbh.execute("SELECT * FROM profile WHERE cats > ?", 2)
  sth.fetch do |row|
    printf "id: %s, name: %s, cats: %s\n", row["id"], row["name"], row["cats"]
  end
  sth.finish
#@ _PLACEHOLDER_PREPARE_EXECUTE_2_
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

puts "Construct INSERT statement using quote()"
begin
#@ _QUOTE_
  stmt = sprintf "INSERT INTO profile (name,birth,color,foods,cats)
                  VALUES(%s,%s,%s,%s,%s)",
                 dbh.quote("De'Mont"),
                 dbh.quote("1973-01-12"),
                 dbh.quote(nil),
                 dbh.quote("eggroll"),
                 dbh.quote(4)
  count = dbh.do(stmt)
#@ _QUOTE_
  puts "Statement:"
  puts stmt
  puts "Number of rows inserted: #{count}"
rescue DBI::DatabaseError => e
  puts "Oops, the statement failed"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

dbh.disconnect
