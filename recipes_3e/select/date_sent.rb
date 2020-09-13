#!/usr/bin/ruby
# date_sent.rb: fetch rows, refer to columns by name

require "Cookbook"

dbh = Cookbook.connect

#@ _FRAG_
sth = dbh.execute("SELECT srcuser,
                   DATE_FORMAT(t,'%M %e, %Y') AS date_sent
                   FROM mail")
sth.fetch do |row|
  printf "user: %s, date sent: %s\n", row["srcuser"], row["date_sent"]
end
sth.finish
#@ _FRAG_

dbh.disconnect
