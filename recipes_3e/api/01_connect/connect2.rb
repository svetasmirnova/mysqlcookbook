#!/usr/bin/ruby
# connect2.rb: connect to the MySQL server, showing how to specify
# a port number or Unix domain socket path explicitly.

require "dbi"

# Set the port explicitly

begin
#@ _FRAG_PORT_
  dsn = "DBI:Mysql:host=127.0.0.1;database=cookbook;port=3307"
#@ _FRAG_PORT_
  puts "Connect using DSN = #{dsn}"
  dbh = DBI.connect(dsn, "cbuser", "cbpass")
  puts "Connected"
rescue
  puts "Cannot connect to server"
else
  dbh.disconnect
  puts "Disconnected"
end

# Set the socket file explicitly

begin
#@ _FRAG_SOCKET_
  dsn = "DBI:Mysql:host=localhost;database=cookbook" +
          ";socket=/var/tmp/mysql.sock"
#@ _FRAG_SOCKET_
  puts "Connect using DSN = #{dsn}"
  dbh = DBI.connect(dsn, "cbuser", "cbpass")
  puts "Connected"
rescue
  puts "Cannot connect to server"
else
  dbh.disconnect
  puts "Disconnected"
end
