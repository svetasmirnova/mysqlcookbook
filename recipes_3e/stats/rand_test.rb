#!/usr/bin/ruby
# rand_test.rb: create a frequency distribution of RAND() values.
# This provides a test of the randomness of RAND().

# Method: Draw random numbers in the range from 0 to 1.0,
# and count how many of them occur in .1-sized intervals
# (0 up to .1, .1 up to .2, ..., .9 up *through* 1.0).

require "Cookbook"

npicks = 1000;            # number of times to pick a number
bucket = Array.new(10, 0) # buckets for counting picks in each interval

dbh = Cookbook.connect()

1.upto(npicks) do |i|
  val = dbh.select_one("SELECT RAND()")[0]
  slot = (val.to_f * 10).to_i
  slot = 9 if slot > 9    # put 1.0 in last slot
  bucket[slot] += 1
end

dbh.disconnect()

# Print the resulting frequency distribution

0.upto(9) do |slot|
  printf "%2d  %d\n", slot+1, bucket[slot]
end
