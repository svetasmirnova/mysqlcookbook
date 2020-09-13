#!/usr/bin/python
# post_image.py: enable user to upload image files using post requests

import sys
import os
import cgi
import cookbook

title = "Post Image"

# Print content type header and blank line that separates
# headers from page body

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

# Use multipart encoding because the form contains a file upload field

#@ _PRINT_FILE_FORM_
print('''
<form method="post" enctype="multipart/form-data" action="%s">
Image name:<br />
<input type="text" name="image_name", size="60" />
<br />
Image file:<br />
<input type="file" name="upload_file", size="60" />
<br /><br />
<input type="submit" name="choice" value="Submit" />
</form>
''' % (os.environ['SCRIPT_NAME']))
#@ _PRINT_FILE_FORM_

# Get info for the image file and the name to assign to the image

#@ _GET_FILE_INFO_
form = cgi.FieldStorage()
if form.has_key('upload_file') and form['upload_file'].filename != '':
  image_file = form['upload_file']
else:
  image_file = None
#@ _GET_FILE_INFO_

if form.has_key('image_name') and form['image_name'].value != '':
  image_name = form['image_name'].value
else:
  image_name = None

# Must have either no parameters (in which case that script was just
# invoked for the first time) or both parameters (in which case the form
# was filled in).  If only one was filled in, the user did not fill in the
# form completely.

param_count = 0
if image_file is not None:
  param_count += 1
if image_name is not None:
  param_count += 1

if param_count == 0:      # initial invocation
  print("<p>No file was uploaded.</p>")
elif param_count == 1:      # incomplete form
  print("<p>Please fill in BOTH fields and resubmit the form.</p>")
else:             # a file was uploaded
  # If an image file was uploaded, print some information about it,
  # then save it in the database.
  print("<p>File was uploaded.</p>")
  data = image_file.value
  print("Filename on client host: %s<br />" % image_file.filename )
  print("File MIME type: %s<br />" % image_file.type )
  print("File size: %d" % len(data))

  # Get MIME type, use generic default if not present

  mime_type = image_file.type
  if mime_type is None or mime_type == "":
    mime_type = "application/octet-stream"

  # Save image in database table.  (Use REPLACE to kick out any
  # old image that has the same name.)

  conn = cookbook.connect()
  conn.autocommit = True
  cursor = conn.cursor()
  cursor.execute("REPLACE INTO image (name,type,data) VALUES(%s,%s,%s)", (
                 image_name, mime_type, data))
  cursor.close()
  conn.close()


print("</body>")
print("</html>")
