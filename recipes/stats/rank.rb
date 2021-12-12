#!/usr/bin/ruby
# rank.rb: assign ranks to a set of values

require "Cookbook"

client = Cookbook.connect()

# drop and recreate the t table, then populate it

client.query("DROP TABLE IF EXISTS t")
client.query("CREATE TABLE t (score INT)")
client.query("INSERT INTO t (score) VALUES(5),(4),(4),(3),(2),(2),(2),(1)")

# Assign ranks using position (row number) within the set of values,
# except that tied values all get the rank accorded the first of them.

#@ _ASSIGN_RANKS_
res = client.query("SELECT score FROM t ORDER BY score DESC")
rownum = 0
rank = 0
prev_score = nil
puts "Row\tRank\tScore\n"
res.each do |row|
	score = row.values[0]
	rownum += 1
	rank = rownum if rownum == 1 || prev_score != score
	prev_score = score
	puts "#{rownum}\t#{rank}\t#{score}"
end
#@ _ASSIGN_RANKS_

client.close()
