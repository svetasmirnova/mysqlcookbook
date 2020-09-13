#!/usr/bin/ruby
# phrase.rb: demonstrate HTML-encoding and URL-encoding using
# values in phrase table.

require "cgi"
require "Cookbook"

cgi = CGI.new("html4")

page = ""
title = "Links generated from phrase table"
page << cgi.p { title } + "\n"

dbh = Cookbook.connect

#@ _MAIN_
stmt = "SELECT phrase_val FROM phrase ORDER BY phrase_val"
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    # make sure that the value is a string
    phrase = row[0].to_s
    # URL-encode the phrase value for use in the URL
    url = "/cgi-bin/mysearch.rb?phrase=" + CGI.escape(phrase)
    # HTML-encode the phrase value for use in the link label
    label = CGI.escapeHTML(phrase)
    page << cgi.a("href" => url) { label } + cgi.br
  end
end
#@ _MAIN_

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head { cgi.title { title } } +
    cgi.body() { page }
  }
}
