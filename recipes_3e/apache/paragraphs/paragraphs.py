#!/usr/bin/python
# paragraphs.py: generate HTML paragraphs

import cgi
import cookbook

title = "Query Output Display - Paragraphs"

# Print content type header, blank line that separates
# headers from page body, and first part of page

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

conn = cookbook.connect()

#@ _DISPLAY_PARAGRAPH_
cursor = conn.cursor()
cursor.execute("SELECT NOW(), VERSION(), DATABASE()")
(now, version, db) = cursor.fetchone()
cursor.close()
if db is None:
  db = 'NONE'
para = "Local time on the MySQL server is %s." % now
print("<p>%s</p>" % cgi.escape(para, 1))
para = "The server version is %s." % version
print("<p>%s</p>" % cgi.escape(para, 1))
para = "The default database is %s." % db
print("<p>%s</p>" % cgi.escape(para, 1))
#@ _DISPLAY_PARAGRAPH_

conn.close()

print("</body>")
print("</html>")
