#!/usr/bin/python
# show_params.py: print request parameter names and values

import sys
import os
import cgi
import urlparse
from cookbook_webutils import make_unordered_list

title = "Script Input Parameters"

# Print content type header and blank line that separates
# headers from page body

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

print("<p>Parameters from cgi.FieldStorage():</p>")

#@ _DISPLAY_PARAMS_
#@ _GET_PARAM_NAMES_
params = cgi.FieldStorage()
param_names = params.keys()
#@ _GET_PARAM_NAMES_
param_names.sort()
print("<p>Parameter names: %s</p>" % param_names)
items = []
for name in param_names:
  val = ','.join(params.getlist(name))
  items.append("name=" + name + ", value=" + val)
print(make_unordered_list(items))
#@ _DISPLAY_PARAMS_

# Alternative parameter access using urlparse

print("<p>Parameters from urlparse.parse_qs():</p>")

try:
  params = urlparse.parse_qs(os.environ['QUERY_STRING'])
except:
  params = {}
param_names = params.keys()
param_names.sort()
print("<p>Parameter names: %s</p>" % param_names)
items = []
for name in param_names:      # all items are returned as lists
  val = []
  for item in params[name]:   # iterate through items to get values
    val.append(item)
  val = ','.join(val)         # convert to string for printing
  items.append("name=" + name + ", value=" + val)
print(make_unordered_list(items))

# include forms that can be sent using get or post

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

print('''
<p>Form 1:</p>

<form method="get" action="%s">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>
<br />

<input type="submit" name="choice" value="Submit by get">
</form>

<p>Form 2:</p>

<form method="post" action="%s">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>
<br />

<input type="submit" name="choice" value="Submit by post">
</form>
''' % (os.environ['SCRIPT_NAME'], os.environ['SCRIPT_NAME']))

print("</body>")
print("</html>")
