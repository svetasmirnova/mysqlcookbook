#!/usr/bin/python
# cow_edit.pl: Present a form for editing a record in the cow_order table.
# (Display only; does not actually process submitted contents.)

# Form has fields that are initialized to the column values from a record
# in the table.  (The script uses record 1.)

import sys
import os
import cookbook
from cookbook_utils import *
from cookbook_webutils import *

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key('SCRIPT_NAME'):
  os.environ['SCRIPT_NAME'] = sys.argv[0]

title = "Cow Figurine Order Record Editing Form"

# Print content type header, blank line that separates
# headers from page body, and first part of page

print("Content-Type: text/html")
print("")
print("<html>")
print("<head><title>%s</title></head>" % title)
print("<body>")

conn = cookbook.connect()

# Retrieve a record by ID from the cow_order table

#@ _FETCH_ORDER_INFO_
id = 1      # select record number 1
stmt = '''
  SELECT
    color, size, accessories,
    cust_name, cust_street, cust_city, cust_state
  FROM cow_order WHERE id = %s
'''
cursor = conn.cursor()
cursor.execute(stmt % (id,))
row = cursor.fetchone()
cursor.close()
#@ _FETCH_ORDER_INFO_
if row is None:
  print("<p>No cow_order record for id %s was found.</p>" % id)
  sys.exit(0)

(color, size, accessories, cust_name, cust_street, cust_city, cust_state) = row

print("<p>Values to be loaded into form:</p>")
items = [
  "id = %s (this is a hidden field; use 'show source' to see it)" % id,
  "color = %s" % color,
  "size = %s" % size,
  "accessories = %s" % ",".join(accessories),
  "name = %s" % cust_name,
  "street = %s" % cust_street,
  "city = %s" % cust_city,
  "state = %s" % cust_state,
]
print(make_unordered_list(items, True))

# accessories is a Set value - convert to a list
#@ _SPLIT_ACCESSORY_VALUE_
acc_val = []
if accessories is not None:
  for val in accessories:
    acc_val.append(val)
#@ _SPLIT_ACCESSORY_VALUE_

# Retrieve values for color list

#@ _FETCH_COLOR_LIST_
color_values = []
stmt = "SELECT color FROM cow_color ORDER BY color"
cursor = conn.cursor()
cursor.execute(stmt)
for (val, ) in cursor:
  color_values.append(val)
cursor.close()
#@ _FETCH_COLOR_LIST_

# Retrieve metadata for size and accessory columns

#@ _FETCH_SIZE_INFO_
size_info = get_enumorset_info(conn, "cookbook", "cow_order", "size")
#@ _FETCH_SIZE_INFO_
#@ _FETCH_ACCESSORY_INFO_
acc_info = get_enumorset_info(conn, "cookbook", "cow_order", "accessories")
#@ _FETCH_ACCESSORY_INFO_

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
state_values = []
state_labels = []
stmt = "SELECT abbrev, name FROM states ORDER BY name"
cursor = conn.cursor()
cursor.execute(stmt)
for (abbrev, name) in cursor:
  state_values.append(abbrev)
  state_labels.append(name)
cursor.close()
#@ _FETCH_STATE_LIST_

conn.close()

# Generate various types of form elements, using the cow_order record
# to provide the default value for each element.

#@ _PRINT_START_FORM_
print('<form action="%s" method="post">' % os.environ['SCRIPT_NAME'])
#@ _PRINT_START_FORM_

# Put ID value into a hidden field

#@ _PRINT_ID_HIDDEN_
print(make_hidden_field("id", id))
#@ _PRINT_ID_HIDDEN_

# Use color list to generate a pop-up menu

#@ _PRINT_COLOR_POPUP_
print("<br />Cow color:<br />")
print(make_popup_menu("color", color_values, color_values, color))
#@ _PRINT_COLOR_POPUP_

# Use size column ENUM information to generate radio buttons

#@ _PRINT_SIZE_RADIO_
print("<br />Cow figurine size:<br />")
print(make_radio_group("size",
                        size_info["values"],
                        size_info["values"],
                        size,
                        True))    # display items vertically
#@ _PRINT_SIZE_RADIO_

# Use accessory column SET information to generate checkboxes

#@ _PRINT_ACCESSORY_CHECKBOX_
print("<br />Cow accessory items:<br />")
print(make_checkbox_group("accessories[]",
                           acc_info["values"],
                           acc_info["values"],
                           acc_val,
                           True))    # display items vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

#@ _PRINT_CUST_NAME_TEXT_
print("<br />Customer name:<br />")
print(make_text_field("cust_name", cust_name, 60))
#@ _PRINT_CUST_NAME_TEXT_

#@ _PRINT_CUST_STREET_TEXT_
print("<br />Customer street address:<br />")
print(make_text_field("cust_street", cust_street, 60))
#@ _PRINT_CUST_STREET_TEXT_

#@ _PRINT_CUST_CITY_TEXT_
print("<br />Customer city:<br />")
print(make_text_field("cust_city", cust_city, 60))
#@ _PRINT_CUST_CITY_TEXT_

#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_
print("<br />Customer state:<br />")
print(make_scrolling_list("cust_state",
                          state_values,
                          state_labels,
                          cust_state,
                          6,        # display 6 items at a time
                          False))   # create single-pick list
#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_

#@ _PRINT_END_FORM_
print("<br />")
print(make_submit_button("choice", "Submit Form"))
print("</form>")
#@ _PRINT_END_FORM_

print("</body>")
print("</html>")
