#!/usr/bin/ruby
# sess_demo.rb: Simple session-stage counter, passing explicit
# connection parameters to session-creation call.

#@ _REQUIRED_MODULES_
require "cgi"
require "cgi/session"
require "mysqlstore"
#@ _REQUIRED_MODULES_

#@ _OPEN_SESSION_
cgi = CGI.new("html4")
sess_id = cgi.cookies["RUBYSESSID"]
session = CGI::Session.new(
            cgi,
            "session_key"      => "RUBYSESSID",
            "database_manager" => CGI::Session::MySQLStore,
            "db.host"          => "localhost",
            "db.user"          => "cbuser",
            "db.pass"          => "cbpass",
            "db.name"          => "cookbook",
            "db.table"         => "ruby_session",
            "db.hold_conn"     => 1
          )
#@ _OPEN_SESSION_

sess_id = session.session_id

count = session["count"]
count = 0 if count.nil?
count = count.to_i + 1
session["count"] = count.to_s

session.close

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
