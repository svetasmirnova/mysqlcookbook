# Cookbook.rb: library file with utility method for connecting to MySQL
# using the Ruby DBI module

require "dbi"

# Establish a connection to the cookbook database, returning a database
# handle.  Raise an exception if the connection cannot be established.

class Cookbook
  @@host_name = "localhost"
  @@db_name = "cookbook"
  @@user_name = "cbuser"
  @@password = "cbpass"

  # Class method for connecting to server to access the
  # cookbook database; returns a database handle object.

  def Cookbook.connect
    return DBI.connect("DBI:Mysql:host=#{@@host_name};database=#{@@db_name}",
                       @@user_name, @@password)
  end
end
