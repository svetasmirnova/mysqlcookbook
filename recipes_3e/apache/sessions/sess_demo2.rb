#!/usr/bin/ruby
# sess_demo2.rb: Simple session-stage counter, passing open database
# handle to session-creation call (and closing the handle after closing
# the session).

require "Cookbook"
require "cgi"
require "cgi/session"
require "mysqlstore"

dbh = Cookbook.connect

#@ _OPEN_SESSION_
cgi = CGI.new("html4")
sess_id = cgi.cookies["RUBYSESSID"]
session = CGI::Session.new(
            cgi,
            "session_key"      => "RUBYSESSID",
            "database_manager" => CGI::Session::MySQLStore,
            "db.dbh"           => dbh,
            "db.name"          => "cookbook",
            "db.table"         => "ruby_session"
          )
#@ _OPEN_SESSION_

sess_id = session.session_id

count = session["count"]
count = 0 if count.nil?
count = count.to_i + 1
session["count"] = count.to_s

session.close

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head { cgi.title{"Ruby Session Demo"} } +
    cgi.body() {
      cgi.p {"sess_id=#{sess_id}"} +
      cgi.p {"This session has been active for #{count} requests."} +
      cgi.p {"Reload page to send next request."}
    }
  }
}
