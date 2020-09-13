#!/usr/bin/python
# banner.py: serve randomly chosen banner ad from image table
# (sends no response if no image can be found)

import cookbook

conn = cookbook.connect()

stmt = "SELECT type, data FROM image ORDER BY RAND() LIMIT 1"
cursor = conn.cursor()
cursor.execute(stmt)
row = cursor.fetchone()
cursor.close()
if row is not None:
  (type, data) = row
  # Send image to client, preceded by Content-Type: and
  # Content-Length: headers.  The Expires:, Cache-Control:, and
  # Pragma: headers help keep browsers from caching the image
  # and reusing it for successive requests for this script.
  print("Content-Type: %s" % type)
  print("Content-Length: %s" % len(data))
  print("Expires: Sat, 01 Jan 2000 00:00:00 GMT")
  print("Cache-Control: no-cache")
  print("Pragma: no-cache")
  print("")
  print(data)

conn.close()
