#!/usr/bin/python
# mysql_status.py: print some MySQL server status information

import cookbook

# Print header, blank line, and initial part of page

print('''Content-Type: text/html

<html>
<head><title>MySQL Server Status</title></head>
<body>
''')

# Connect to database
conn = cookbook.connect()

# Retrieve status information
cursor = conn.cursor()
cursor.execute("SELECT NOW(), VERSION()")
(now, version) = cursor.fetchone()
# SHOW STATUS variable values are in second result column
cursor.execute("SHOW GLOBAL STATUS LIKE 'Questions'")
queries = cursor.fetchone()[1]
cursor.execute("SHOW GLOBAL STATUS LIKE 'Uptime'")
uptime = cursor.fetchone()[1]
q_per_sec = "%0.2f" % (float(queries) / float(uptime))
cursor.close()

# Disconnect from database
conn.close()

# Display status report
print("<p>Current time: %s</p>" % now)
print("<p>Server version: %s</p>" % version)
print("<p>Server uptime (seconds): %s</p>" % uptime)
print("<p>Queries processed: %s (%s queries/second)</p>"
      % (queries, q_per_sec))

# Print page trailer
print('''
</body>
</html>
''')
