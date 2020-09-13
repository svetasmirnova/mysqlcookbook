#!/usr/bin/python
# show_tables.py: Display names of tables in cookbook database

import cookbook

# Print header, blank line, and initial part of page

print('''Content-Type: text/html

<html>
<head><title>Tables in cookbook Database</title></head>
<body>

<p>Tables in cookbook database:</p>
''')

# Connect to database, display table list, disconnect

conn = cookbook.connect()
cursor = conn.cursor()
stmt = '''
  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = 'cookbook' ORDER BY TABLE_NAME
'''
cursor.execute(stmt)
for (tbl_name, ) in cursor:
  print("%s<br />" % tbl_name)
cursor.close()
conn.close()

# Print page trailer
print('''
</body>
</html>
''')
