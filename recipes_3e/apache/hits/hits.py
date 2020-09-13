#!/usr/bin/python
# hits.py: web page hit-counter example

import sys
import os
import cgi
import cookbook

#@ _GET_HIT_COUNT_
def get_hit_count(conn, page_path):
  cursor = conn.cursor()
  cursor.execute('''
                 INSERT INTO hitcount (path,hits)
                 VALUES(%s,LAST_INSERT_ID(1))
                 ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)
                 ''', (page_path,))
  count = cursor.lastrowid
  cursor.close()
  conn.commit()
  return count
#@ _GET_HIT_COUNT_

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

title = "Hit Count Example"

# Print content type header, blank line that separates
# headers from page body, and first part of page

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

conn = cookbook.connect()

print("<p>Page path: %s</p>" % cgi.escape(os.environ['SCRIPT_NAME'], 1))

# Display a hit count

#@ _DISPLAY_HIT_COUNT_
count = get_hit_count(conn, os.environ['SCRIPT_NAME'])
print("<p>This page has been accessed %d times.</p>" % count)
#@ _DISPLAY_HIT_COUNT_

# Use a logging approach to hit recording.  This enables
# the most recent hits to be displayed.

if os.environ.has_key('REMOTE_HOST'):
  host = os.environ['REMOTE_HOST']
elif os.environ.has_key('REMOTE_ADDR'):
  host = os.environ['REMOTE_ADDR']
else:
  host = 'UNKNOWN'

cursor = conn.cursor()
cursor.execute('''
               INSERT INTO hitlog (path, host) VALUES(%s,%s)
               ''', (os.environ['SCRIPT_NAME'], host))
conn.commit()

# Display the most recent hits for the page

cursor.execute('''
               SELECT DATE_FORMAT(t, '%%Y-%%m-%%d %%T'), host
               FROM hitlog
               WHERE path = %s ORDER BY t DESC LIMIT 10
               ''', (os.environ['SCRIPT_NAME'], ))
print('<p>Most recent hits:</p>')
print('<table border="1">')
print('<tr><th>%s</th><th>%s</th></tr>' % ('Date', 'Host'))
for (date, host) in cursor:
  print('<tr><td>%s</td><td>%s</td></tr>' %
        (cgi.escape(date), cgi.escape(host)))
print('</table>')

cursor.close()
conn.close()

print("</body>")
print("</html>")
