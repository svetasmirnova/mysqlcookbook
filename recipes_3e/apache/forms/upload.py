#!/usr/bin/python
# upload.py: file upload demonstration

# This script demonstrates how to generate a form that includes a
# file upload field, and how to obtain information about a file and
# read its contents when one is uploaded.  The script does not save
# the file anywhere, so it is discarded when the script exits.

import sys
import os
import cgi

title = "File Upload Demo"

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

# Print content type header and blank line that separates
# headers from page body

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

#@ _GET_FILE_INFO_
form = cgi.FieldStorage()
if form.has_key('upload_file') and form['upload_file'].filename != '':
  print("<p>File was uploaded</p>")
  upload_file = form['upload_file']
  print("Filename on client host: %s<br />" % upload_file.filename )
  print("File MIME type: %s<br />" % upload_file.type )
  print("File size: %d" % len(upload_file.value))
else:
  print("<p>File was not uploaded</p>")
#@ _GET_FILE_INFO_

#@ _UPLOAD_FORM_
print('''
<form enctype="multipart/form-data" method="post" action="%s">
<p>File to upload:</p>
<input type="file" name="upload_file", size="60" />
<br /><br />
<input type="submit" name="choice" value="Submit" />
</form>
''' % (os.environ['SCRIPT_NAME']))
#@ _UPLOAD_FORM_

print("</body>")
print("</html>")
