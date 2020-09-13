#!/usr/bin/ruby
# hitrate.rb: Show InnoDB and MyISAM key cache hit rate statistics

# The Cookbook discusses the possibility making get_status_variables()
# a library routine, but the routine is actually included here directly,
# not pulled from a library.
# Ditto get_system_variables().

# The get_{status,system}_variables_alt() methods are alternative
# implementations of get_{status,system}_variables() that retrieve
# information using SHOW rather than INFORMATION_SCHEMA tables.

require "Cookbook"

# Read INFORMATION_SCHEMA.GLOBAL_STATUS to get status variables.
# Read INFORMATION_SCHEMA.GLOBAL_VARIABLES to get system variables.
# In each case, construct hash of of variable name/value pairs, keyed by name.
# Force variable names to uppercase.

#@ _GET_STATUS_VARIABLES_
def get_status_variables(dbh)
  vars = {}
  query = "SELECT VARIABLE_NAME, VARIABLE_VALUE FROM
           INFORMATION_SCHEMA.GLOBAL_STATUS"
  dbh.select_all(query).each { |name, value| vars[name.upcase] = value }
  return vars
end
#@ _GET_STATUS_VARIABLES_

#@ _GET_SYSTEM_VARIABLES_
def get_system_variables(dbh)
  vars = {}
  query = "SELECT VARIABLE_NAME, VARIABLE_VALUE FROM
           INFORMATION_SCHEMA.GLOBAL_VARIABLES"
  dbh.select_all(query).each { |name, value| vars[name.upcase] = value }
  return vars
end
#@ _GET_SYSTEM_VARIABLES_

# Alternative implementations that use SHOW

def get_status_variables_alt(dbh)
  vars = {}
#@ _STATUS_FROM_SHOW_
  query = "SHOW GLOBAL STATUS"
#@ _STATUS_FROM_SHOW_
  dbh.select_all(query).each { |name, value| vars[name.upcase] = value }
  return vars
end

def get_system_variables_alt(dbh)
  vars = {}
#@ _SYSTEM_FROM_SHOW_
  query = "SHOW GLOBAL VARIABLES"
#@ _SYSTEM_FROM_SHOW_
  dbh.select_all(query).each { |name, value| vars[name.upcase] = value }
  return vars
end

# Calculate cache hit rate. Arguments are the hash containing status
# variable information and the names of the status variables that
# indicate the number of reads and read requests.

#@ _CACHE_HIT_RATE_
def cache_hit_rate(vars,reads_name,requests_name)
  reads = vars[reads_name].to_f
  requests = vars[requests_name].to_f
  hit_rate = requests == 0 ? 0 : 1 - (reads/requests)
  printf "        Key reads: %12d (%s)\n", reads, reads_name
  printf "Key read requests: %12d (%s)\n", requests, requests_name
  printf "         Hit rate: %12.4f\n", hit_rate
end
#@ _CACHE_HIT_RATE_

begin
  dbh = Cookbook.connect
rescue DBI::DatabaseError => e
  puts "Could not connect to server"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
end

#@ _KEY_CACHE_
statvars = get_status_variables(dbh)
cache_hit_rate(statvars,
               "INNODB_BUFFER_POOL_READS",
               "INNODB_BUFFER_POOL_READ_REQUESTS")
cache_hit_rate(statvars,
               "KEY_READS",
               "KEY_READ_REQUESTS")
#@ _KEY_CACHE_

dbh.disconnect

