#!/usr/bin/ruby
# links.rb: generate HTML hyperlinks

require "cgi"
require "Cookbook"
require "Cookbook_Webutils"

title = "Query Output Display - Hyperlinks"

cgi = CGI.new("html4")
page = ""

dbh = Cookbook.connect

page << cgi.p { "Book vendors as static text:" }

#@ _DISPLAY_STATIC_URL_
stmt = "SELECT name, website FROM book_vendor ORDER BY name"
list = ""
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    list << cgi.li {
              CGI.escapeHTML("Vendor: #{row[0]}, website: http://#{row[1]}")
            }
  end
end
list = cgi.ul { list }
#@ _DISPLAY_STATIC_URL_
page << list

page << cgi.p { "Book vendors as hyperlinks:" }
#@ _DISPLAY_HYPERLINK_URL_
stmt = "SELECT name, website FROM book_vendor ORDER BY name"
list = ""
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    list << cgi.li {
              cgi.a("href" => "http://#{row[1]}") {
                CGI.escapeHTML(row[0].to_s)
              }
            }
  end
end
list = cgi.ul { list }
#@ _DISPLAY_HYPERLINK_URL_
page << list

page << cgi.p { "Email directory:" }
#@ _DISPLAY_EMAIL_LIST_
stmt = "SELECT department, name, email FROM newsstaff
        ORDER BY department, name"
list = ""
dbh.execute(stmt) do |sth|
  sth.fetch do |dept, name, email|
    list << cgi.li {
              CGI.escapeHTML(dept.to_s) + ": " + make_email_link(name, email)
            }
  end
end
list = cgi.ul { list }
#@ _DISPLAY_EMAIL_LIST_
page << list

page << cgi.p { "Some sample invocations of make_email_link():" }
page << cgi.p { "Name + address: " +
          make_email_link("Rex Conex", "rconex@wrrr-news.com") }
page << cgi.p { "Name + nil address: " +
          make_email_link("Rex Conex", nil) }
page << cgi.p { "Name + empty string address: " +
          make_email_link("Rex Conex", "") }
page << cgi.p { "Name + missing address: " +
          make_email_link("Rex Conex") }
page << cgi.p { "Address as name: " +
          make_email_link("rconex@wrrr-news.com", "rconex@wrrr-news.com") }

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head {
      cgi.title { title }
    } +
    cgi.body() { page }
  }
}
