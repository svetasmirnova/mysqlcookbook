#!/usr/bin/python
# form_element.py: generate form elements from database contents

# To Do:
# - Call all functions to make sure they die on bad arguments
# - Think about using named parameters

import sys
import os
import cookbook
from cookbook_utils import *
from cookbook_webutils import *

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

title = "Form Element Generation"

# Print content type header, blank line that separates
# headers from page body, and first part of page

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

conn = cookbook.connect()

print('<form action="%s" method="post">' % os.environ['SCRIPT_NAME'])

# Retrieve values for color list (also used for labels)

#@ _FETCH_COLOR_LIST_
values = []
stmt = "SELECT color FROM cow_color ORDER BY color"
cursor = conn.cursor()
cursor.execute(stmt)
for (color, ) in cursor:
  values.append(color)
cursor.close()
#@ _FETCH_COLOR_LIST_

# Use color list to generate single-pick form elements

print("<p>Cow color:</p>")

print("<p>As radio button group:</p>")
#@ _PRINT_COLOR_RADIO_
print(make_radio_group('color', values, values, '', True))
#@ _PRINT_COLOR_RADIO_

print("<p>As popup menu (using fetch-and-print-loop):</p>")
#@ _FETCH_AND_PRINT_COLOR_LIST_
stmt = "SELECT color FROM cow_color ORDER BY color"
cursor = conn.cursor()
cursor.execute(stmt)
print('<select name="color">')
for (color, ) in cursor:
  color = cgi.escape(color, 1)
  print('<option value="%s">%s</option>' % (color, color))
print('</select>')
cursor.close()
#@ _FETCH_AND_PRINT_COLOR_LIST_

print("<p>As popup menu (using utility function):</p>")
#@ _PRINT_COLOR_POPUP_
print(make_popup_menu('color', values, values, ''))
#@ _PRINT_COLOR_POPUP_

print("<p>As single-pick scrolling list:</p>")
#@ _PRINT_COLOR_SCROLLING_SINGLE_
print(make_scrolling_list('color', values, values, '', 3, False))
#@ _PRINT_COLOR_SCROLLING_SINGLE_

# Add a "Please choose a color" item to head of the list

print("<p>As popup menu with initial no-choice item:</p>")
#@ _PLEASE_CHOOSE_COLOR_
values.insert(0, "Please choose a color")
print(make_popup_menu('color', values, values, '0'))
#@ _PLEASE_CHOOSE_COLOR_

print("<hr />")
print("<p>Cow figurine size:</p>")

# Retrieve metadata for size column

#@ _FETCH_SIZE_INFO_
size_info = get_enumorset_info(conn, 'cookbook', 'cow_order', 'size')
#@ _FETCH_SIZE_INFO_

# Use ENUM column information to generate single-pick list elements

print("<p>As radio button group:</p>")
#@ _PRINT_SIZE_RADIO_
print(make_radio_group('size',
                       size_info['values'],
                       size_info['values'],
                       size_info['default'],
                       True))  # display items vertically
#@ _PRINT_SIZE_RADIO_

print("<p>As popup menu:</p>")
#@ _PRINT_SIZE_POPUP_
print(make_popup_menu('size',
                      size_info['values'],
                      size_info['values'],
                      size_info['default']))
#@ _PRINT_SIZE_POPUP_

print("<p>As single-pick scrolling list:</p>")
print("<p>(skipped; too few items)</p>")

print("<hr />")
print("<p>Cow accessories:</p>")

# Retrieve metadata for accessory column

#@ _FETCH_ACCESSORY_INFO_
acc_info = get_enumorset_info(conn, 'cookbook', 'cow_order', 'accessories')
#@ _FETCH_ACCESSORY_INFO_
#@ _SPLIT_ACCESSORY_DEFAULT_
if acc_info['default'] is None:
  acc_def = ""
else:
  acc_def = acc_info['default'].split(',')
#@ _SPLIT_ACCESSORY_DEFAULT_

# Use SET column information to generate multiple-pick list elements

print("<p>As checkbox group:</p>")
#@ _PRINT_ACCESSORY_CHECKBOX_
print(make_checkbox_group('accessories',
                          acc_info['values'],
                          acc_info['values'],
                          acc_def,
                          True))  # display items vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

print("<p>As multiple-pick scrolling list:</p>")
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_
print(make_scrolling_list('accessories',
                          acc_info['values'],
                          acc_info['values'],
                          acc_def,
                          3,      # display 3 items at a time
                          True))  # create multiple-pick list
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_

print("<hr />")
print("<p>State of residence:</p>")

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
values = []
labels = []
stmt = "SELECT abbrev, name FROM states ORDER BY name"
cursor = conn.cursor()
cursor.execute(stmt)
for (abbrev, name) in cursor:
  values.append(abbrev)
  labels.append(name)
cursor.close()
#@ _FETCH_STATE_LIST_

# Use state list to generate single-pick form elements

print("<p>As radio button group:</p>")
print("(skipped; too many items)")

print("<p>As popup menu (using fetch-and-print loop):</p>")
#@ _FETCH_AND_PRINT_STATE_LIST_
stmt = "SELECT abbrev, name FROM states ORDER BY name"
cursor = conn.cursor()
cursor.execute(stmt)
print('<select name="state">')
for (abbrev, name) in cursor:
  abbrev = cgi.escape(abbrev, 1)
  name = cgi.escape(name, 1)
  print('<option value="%s">%s</option>' % (abbrev, name))
print('</select>')
cursor.close()
#@ _FETCH_AND_PRINT_STATE_LIST_

print("<p>As popup menu (using utility function):</p>")
#@ _PRINT_STATE_POPUP_
print(make_popup_menu('state', values, labels, ''))
#@ _PRINT_STATE_POPUP_

print("<p>As single-pick scrolling list:</p>")
#@ _PRINT_STATE_SCROLLING_SINGLE_
print(make_scrolling_list('state', values, labels, '', 6, False))
#@ _PRINT_STATE_SCROLLING_SINGLE_

# Add a "Please choose a state" item to head of the list

print("<p>As popup menu with initial no-choice item:</p>")
#@ _PLEASE_CHOOSE_STATE_
values.insert(0, '0')
labels.insert(0, "Please choose a state")
print(make_popup_menu('state', values, labels, '0'))
#@ _PLEASE_CHOOSE_STATE_

print("</form>")

print("</body>")
print("</html>")

conn.close()
