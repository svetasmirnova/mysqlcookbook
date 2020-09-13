#!/usr/bin/ruby

require "Cookbook"

# Print header, blank line, and initial part of page

puts "Content-Type: text/html"
puts ""

puts "
<html>
<head><title>Ruby Web Connect Page</title></head>
<body>
"

# Connect to and disconnect from database
dbh = Cookbook.connect
puts "<p>Connected</p>"
dbh.disconnect
puts "<p>Disconnected</p>"

# Print page trailer
puts "
</body>
</html>
"
