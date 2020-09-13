#!/usr/bin/python
# download.py: retrieve result set and send it to user as a download
# rather than for display in a web page

import sys
import os
import cgi
import cookbook

title = "Result Set Downloading Example"

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

# If no download parameter is present, display instruction page

param = cgi.FieldStorage()
if not param.has_key('download'):
  print("Content-Type: text/html")
  print("")
  print("<html>")
  print("<head><title>%s</title></head>" % title)
  print("<body>")
  print("<p>")
  print("Select the following link to commence downloading:")
  # construct self-refential URL that includes download parameter
  print('<a href="%s?download=1">download</a>' % os.environ['SCRIPT_NAME'])
  print("</p>")
  print("</body>")
  print("</html>")
  sys.exit(0)

# The download parameter was present; retrieve a result set and send
# it to the client as a tab-delimited, newline-terminated document.
# Use a content type of application/octet-stream in an attempt to
# trigger a download response by the browser, and suggest a default
# filename of "result.txt".

print('Content-Type: application/octet-stream')
print('Content-Disposition: attachment; filename="result.txt"')
print('')

stmt = "SELECT * FROM profile"

conn = cookbook.connect()
cursor = conn.cursor()
cursor.execute(stmt)
for row in cursor:
  row = map(str, row)      # force each value to be a string
  print("\t".join(row))
cursor.close()
conn.close()
