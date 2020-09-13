#!/usr/bin/ruby
# show_tables.rb: Display names of tables in cookbook database

require "cgi"
require "Cookbook"

# Connect to database, generate table list, disconnect

dbh = Cookbook.connect
stmt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME"
rows = dbh.select_all(stmt)
dbh.disconnect

cgi = CGI.new("html4")

cgi.out {
  cgi.html {
    cgi.head {
      cgi.title { "Tables in cookbook Database" }
    } +
    cgi.body() {
      cgi.p { "Tables in cookbook Database:" } +
      rows.collect { |row| row[0] + cgi.br }.join
    }
  }
}

