#!/usr/bin/ruby
# cmdline.rb: demonstrate command-line option parsing in Ruby

require "getoptlong"
require "dbi"

# connection parameters - all missing (nil) by default
host_name = nil
password = nil
user_name = nil

opts = GetoptLong.new(
  [ "--host",     "-h", GetoptLong::REQUIRED_ARGUMENT ],
  [ "--password", "-p", GetoptLong::REQUIRED_ARGUMENT ],
  [ "--user",     "-u", GetoptLong::REQUIRED_ARGUMENT ]
)

# iterate through options, extracting whatever values are present;
# opt is the long-format option, arg is its value
opts.each do |opt, arg|
  case opt
  when "--host"
    host_name = arg
  when "--password"
    password = arg
  when "--user"
    user_name = arg
  end
end

# any nonoption arguments remain in ARGV
# and can be processed here as necessary

# construct data source name
dsn = "DBI:Mysql:database=cookbook"
dsn << ";host=#{host_name}" unless host_name.nil?

# connect to server
begin
  dbh = DBI.connect(dsn, user_name, password)
  puts "Connected"
rescue DBI::DatabaseError => e
  puts "Cannot connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
  exit(1)
end

dbh.disconnect()
puts "Disconnected"
