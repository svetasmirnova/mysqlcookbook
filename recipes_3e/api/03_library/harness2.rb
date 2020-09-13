#!/usr/bin/ruby
# harness2.rb: test harness for Cookbook.rb library

# Does not catch exceptions, so this script simply dies if
# a connect error occurs.

require "Cookbook"

#@ _FRAG_
dbh = Cookbook.connect
print "Connected\n"
dbh.disconnect
print "Disconnected\n"
#@ _FRAG_
