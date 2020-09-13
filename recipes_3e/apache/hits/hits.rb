#!/usr/bin/ruby
# hits.rb: web page hit-counter example

require "cgi"
require "Cookbook"

#@ _GET_HIT_COUNT_
def get_hit_count(dbh, page_path)
  dbh.do("INSERT INTO hitcount (path,hits) VALUES(?,LAST_INSERT_ID(1))
          ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)",
         page_path)
  return dbh.func(:insert_id)
end
#@ _GET_HIT_COUNT_

# If script is run from the command line, ENV["SCRIPT_NAME"] won't exist;
# fake it by using script name.

ENV["SCRIPT_NAME"] = $0 if ENV["SCRIPT_NAME"].nil?

title = "Hit Count Example"
page = ""

cgi = CGI.new("html4")

dbh = Cookbook.connect

page << cgi.p { "Page path: " + CGI.escapeHTML(ENV["SCRIPT_NAME"].to_s) }

#@ _DISPLAY_HIT_COUNT_
count = get_hit_count(dbh, ENV["SCRIPT_NAME"])
page << cgi.p { "This page has been accessed #{count} times." }
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This enables
# the most recent hits to be displayed.

if ENV["REMOTE_HOST"]
  host = ENV["REMOTE_HOST"]
elsif ENV["REMOTE_ADDR"]
  host = ENV["REMOTE_ADDR"]
else
  host = "UNKNOWN"
end

dbh.do("INSERT INTO hitlog (path, host) VALUES(?,?)", ENV["SCRIPT_NAME"], host)

# Display the most recent hits for the page

page << cgi.p { "Most recent hits:" }
table_rows = cgi.tr {
               cgi.th { "Date" } +
               cgi.th { "Host" }
             }
stmt = "SELECT DATE_FORMAT(t, '%Y-%m-%d %T'), host
        FROM hitlog
        WHERE path = ? ORDER BY t DESC LIMIT 10"
dbh.execute(stmt, ENV["SCRIPT_NAME"]) do |sth|
  sth.fetch do |row|
    row.collect! do |val| CGI.escapeHTML(val.to_s) end
    table_rows << cgi.tr {
                    cgi.td { row[0] } +
                    cgi.td { row[1] }
                  }
  end
end
page << cgi.table("border" => "1") { table_rows }

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head { cgi.title { title } } +
    cgi.body() { page }
  }
}
