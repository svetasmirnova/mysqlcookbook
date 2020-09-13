#!/usr/bin/ruby
# paragraphs.rb: generate HTML paragraphs

require "cgi"
require "Cookbook"

title = "Query Output Display - Paragraphs"

dbh = Cookbook.connect

#@ _DISPLAY_PARAGRAPH_1_
(now, version, db) =
  dbh.select_one("SELECT NOW(), VERSION(), DATABASE()")
db = "NONE" if db.nil?
#@ _DISPLAY_PARAGRAPH_1_

dbh.disconnect

#@ _DISPLAY_PARAGRAPH_2_
cgi = CGI.new("html4")
cgi.out {
  cgi.p { CGI.escapeHTML("Local time on the MySQL server is #{now}.") } +
  cgi.p { CGI.escapeHTML("The server version is #{version}.") } +
  cgi.p { CGI.escapeHTML("The default database is #{db}.") }
}
#@ _DISPLAY_PARAGRAPH_2_
