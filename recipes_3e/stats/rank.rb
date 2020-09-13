#!/usr/bin/ruby
# rank.rb: assign ranks to a set of values

require "Cookbook"

dbh = Cookbook.connect()

# drop and recreate the t table, then populate it

dbh.do("DROP TABLE IF EXISTS t")
dbh.do("CREATE TABLE t (score INT)")
dbh.do("INSERT INTO t (score) VALUES(5),(4),(4),(3),(2),(2),(2),(1)")

# Assign ranks using position (row number) within the set of values,
# except that tied values all get the rank accorded the first of them.

#@ _ASSIGN_RANKS_
dbh.execute("SELECT score FROM t ORDER BY score DESC") do |sth|
  rownum = 0
  rank = 0
  prev_score = nil
  puts "Row\tRank\tScore\n"
  sth.fetch do |row|
    score = row[0]
    rownum += 1
    rank = rownum if rownum == 1 || prev_score != score
    prev_score = score
    puts "#{rownum}\t#{rank}\t#{score}"
  end
end
#@ _ASSIGN_RANKS_

dbh.disconnect()
