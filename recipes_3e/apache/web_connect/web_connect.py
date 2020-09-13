#!/usr/bin/python

import cookbook

print('''Content-Type: text/html

<html>
<head><title>Python Web Connect Page</title></head>
<body>
''')

conn = cookbook.connect()
print("<p>Connected</p>")
conn.close()
print("<p>Disconnected</p>")

print('''
</body>
</html>
''')
