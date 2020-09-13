#!/usr/bin/ruby
# transaction.rb: simple transaction demonstration

# By default, this creates an InnoDB table.  If you specify a storage
# engine on the command line, that will be used instead.  Normally,
# this should be a transaction-safe engine that is supported by your
# server.  However, you can pass a nontransactional storage engine
# to verify that rollback doesn't work properly for such engines.

# The script uses a table named "money" and drops it if necessary.
# Change the name if you have a valuable table with that name. :-)

require "Cookbook"

# Create the example table and populate it with a couple of rows

def init_table(dbh, tbl_engine)
  begin
    dbh.do("DROP TABLE IF EXISTS money")
    dbh.do("CREATE TABLE money (name CHAR(5), amt INT) ENGINE = " +
                              tbl_engine)
    dbh.do("INSERT INTO money (name, amt) VALUES('Eve', 10)")
    dbh.do("INSERT INTO money (name, amt) VALUES('Ida', 0)")
  rescue DBI::DatabaseError => e
    puts "Cannot initialize test table"
    puts "#{e.err}: #{e.errstr}"
  end
end

# Display the current contents of the example table

def display_table(dbh)
  begin
    dbh.execute("SELECT name, amt FROM money").each do |row|
      puts "#{row[0]} has $#{row[1]}"
    end
  rescue DBI::DatabaseError => e
    puts "Cannot display contents of test table"
    puts "#{e.err}: #{e.errstr}"
  end
end

tbl_engine = "InnoDB" # default storage engine
tbl_engine = ARGV[0] if ARGV.length > 0

puts "Using storage engine #{tbl_engine} to test transactions"

dbh = Cookbook.connect

# Use commit()/rollback() methods

puts "----------"
puts "This transaction should succeed."
puts "Table contents before transaction:"
init_table(dbh, tbl_engine)
display_table(dbh)

#@ _DO_TRANSACTION_1_
begin
  dbh['AutoCommit'] = false
  dbh.do("UPDATE money SET amt = amt - 6 WHERE name = 'Eve'")
  dbh.do("UPDATE money SET amt = amt + 6 WHERE name = 'Ida'")
  dbh.commit
  dbh['AutoCommit'] = true
rescue DBI::DatabaseError => e
  puts "Transaction failed, rolling back. Error was:"
  puts "#{e.err}: #{e.errstr}"
  begin           # empty exception handler in case rollback fails
    dbh.rollback
    dbh['AutoCommit'] = true
  rescue
  end
end
#@ _DO_TRANSACTION_1_

puts "Table contents after transaction:"
display_table(dbh)

# Use transaction() method

puts "----------"
puts "This transaction should succeed."
puts "Table contents before transaction:"
init_table(dbh, tbl_engine)
display_table(dbh)

#@ _DO_TRANSACTION_2_
begin
  dbh['AutoCommit'] = false
  dbh.transaction do |dbh|
    dbh.do("UPDATE money SET amt = amt - 6 WHERE name = 'Eve'")
    dbh.do("UPDATE money SET amt = amt + 6 WHERE name = 'Ida'")
  end
  dbh['AutoCommit'] = true
rescue DBI::DatabaseError => e
  puts "Transaction failed, rolling back. Error was:"
  puts "#{e.err}: #{e.errstr}"
  dbh['AutoCommit'] = true
end
#@ _DO_TRANSACTION_2_

puts "Table contents after transaction:"
display_table(dbh)

# Use commit()/rollback() methods

puts "----------"
puts "This transaction should fail."
puts "Table contents before transaction:"
init_table(dbh, tbl_engine)
display_table(dbh)

begin
  dbh['AutoCommit'] = false
  dbh.do("UPDATE money SET amt = amt - 6 WHERE name = 'Eve'")
  dbh.do("UPDATE money SET xamt = xamt + 6 WHERE name = 'Ida'")
  dbh.commit
  dbh['AutoCommit'] = true
rescue DBI::DatabaseError => e
  puts "Transaction failed, rolling back. Error was:"
  puts "#{e.err}: #{e.errstr}"
  begin           # empty exception handler in case rollback fails
    dbh.rollback
    dbh['AutoCommit'] = true
  rescue
  end
end

puts "Table contents after transaction:"
display_table(dbh)

# Use transaction() method

puts "----------"
puts "This transaction should fail."
puts "Table contents before transaction:"
init_table(dbh, tbl_engine)
display_table(dbh)

begin
  dbh['AutoCommit'] = false
  dbh.transaction do |dbh|
    dbh.do("UPDATE money SET amt = amt - 6 WHERE name = 'Eve'")
    dbh.do("UPDATE money SET xamt = xamt + 6 WHERE name = 'Ida'")
  end
  dbh['AutoCommit'] = true
rescue DBI::DatabaseError => e
  puts "Transaction failed, rolling back. Error was:"
  puts "#{e.err}: #{e.errstr}"
  dbh['AutoCommit'] = true
end

puts "Table contents after transaction:"
display_table(dbh)

dbh.disconnect
