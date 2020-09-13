#!/usr/bin/ruby
# sess_track.rb: session request counting/timestamping demonstration

require "Cookbook"
require "cgi"
require "cgi/session"
require "mysqlstore"

title = "Ruby Session Tracker";

dbh = Cookbook::connect

#@ _OPEN_SESSION_
cgi = CGI.new("html4")
session = CGI::Session.new(
            cgi,
            "session_key"      => "RUBYSESSID",
            "database_manager" => CGI::Session::MySQLStore,
            "db.dbh"           => dbh,
            "db.name"          => "cookbook",
            "db.table"         => "ruby_session"
          )
#@ _OPEN_SESSION_

# extract string values from session, convert them to the proper types

count = session["count"]
count = (count.nil? ? 0 : count.to_i)
timestamp = session["timestamp"]
timestamp = (timestamp.nil? ? [] : timestamp.split(","))

# increment counter and add current timestamp to timestamp array

count = count + 1
timestamp << Time.now().strftime("%Y-%m-%d %H:%M:%S")

# construct content of page body

page = ""

page << cgi.p {"This session has been active for #{count} requests."}
page << cgi.p {"The requests occurred at these times:"}
page << cgi.ol { timestamp.collect { |t| cgi.li { t.to_s } } }
page << cgi.p {"Reload page to send next request."}

if count < 10     # save modified values into session
  # convert session variables back to strings before saving
  session["count"] = count.to_s
  session["timestamp"] = timestamp.join(",")
  session.close()
else              # destroy session after 10 invocations
  session.delete()
end

dbh.disconnect

# generate the output page

cgi.out {
  cgi.html {
    cgi.head { cgi.title { title } } + cgi.body() { page }
  }
}

