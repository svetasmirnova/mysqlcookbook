#!/usr/bin/ruby
# mysql_status.rb: print some MySQL server status information

require "cgi"
require "Cookbook"

# Connect to database
dbh = Cookbook.connect

# Retrieve status information
now, version = dbh.select_one("SELECT NOW(), VERSION()")
# SHOW STATUS variable values are in second result column
queries = dbh.select_one("SHOW GLOBAL STATUS LIKE 'Questions'")[1]
uptime = dbh.select_one("SHOW GLOBAL STATUS LIKE 'Uptime'")[1]
q_per_sec = sprintf("%.2f", queries.to_f / uptime.to_f)

# Disconnect from database
dbh.disconnect

# Display status report

cgi = CGI.new("html4")

cgi.out {
  cgi.html {
    cgi.head {
      cgi.title { "MySQL Server Status" }
    } +
    cgi.body() {
      cgi.p { "Current time: " + now.to_s } +
      cgi.p { "Server version: " + version.to_s } +
      cgi.p { "Server uptime (seconds): " + uptime.to_s } +
      cgi.p { "Queries processed: " + queries.to_s + " (" +
            q_per_sec.to_s + " queries/second)" }
    }
  }
}
