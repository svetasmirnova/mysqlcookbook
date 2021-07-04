#!/usr/bin/ruby
# get_rs_meta.rb: run a statement and display its result set metadata

# The program runs a default statement, which can be overridden by supplying
# a statement as an argument on the command line.

require "Cookbook"

#@ _DEFAULT_STATEMENT_
stmt = "SELECT name, birth FROM profile"
#@ _DEFAULT_STATEMENT_
# override statement with command line argument if one was given
stmt = ARGV[0] if ARGV.length > 0

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

begin
#@ _DISPLAY_METADATA_
  puts "Statement: #{stmt}"
  sth = dbh.execute(stmt)
  # metadata information becomes available at this point ...
  puts "Number of columns: #{sth.column_names.size}"
  puts "Note: statement has no result set" if sth.column_names.size == 0
  sth.column_info.each_with_index do |info, i|
    puts "--- Column #{i} (#{info['name']}) ---"
    puts "sql_type:         #{info['sql_type']}"
    puts "type_name:        #{info['type_name']}"
    puts "precision:        #{info['precision']}"
    puts "scale:            #{info['scale']}"
    puts "nullable:         #{info['nullable']}"
    puts "indexed:          #{info['indexed']}"
    puts "primary:          #{info['primary']}"
    puts "unique:           #{info['unique']}"
    puts "mysql_type:       #{info['mysql_type']}"
    puts "mysql_type_name:  #{info['mysql_type_name']}"
    puts "mysql_length:     #{info['mysql_length']}"
    puts "mysql_max_length: #{info['mysql_max_length']}"
    puts "mysql_flags:      #{info['mysql_flags']}"
  end
  sth.finish
#@ _DISPLAY_METADATA_
rescue DBI::DatabaseError => e
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

dbh.disconnect
