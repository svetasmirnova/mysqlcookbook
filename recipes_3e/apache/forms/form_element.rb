#!/usr/bin/ruby
# form_element.rb: generate form elements from database contents

# Note: For the radio_group, popup_menu, and scrolling_list methods,
# the value attribure for each item will be HTML-encoded by the cgi
# module, but item content will *not* be encoded, so you must do it
# yourself.

require "cgi"
require "Cookbook"
require "Cookbook_Utils"
require "Cookbook_Webutils"

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

ENV["SCRIPT_NAME"] = $0 unless ENV.has_key?("SCRIPT_NAME")

title = "Form Element Generation"

cgi = CGI.new("html4")
form = ""

dbh = Cookbook.connect

# Retrieve values for color list (also used for labels)

#@ _FETCH_COLOR_LIST_
values = []
stmt = "SELECT color FROM cow_color ORDER BY color"
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    values << row["color"]
  end
end
#@ _FETCH_COLOR_LIST_

# Use color list to generate single-pick form elements

form << cgi.p { "Cow color:" }

form << cgi.p { "As radio button group:" }
#@ _PRINT_COLOR_RADIO_
items = []
values.each do |val|
	items << [ val, CGI.escapeHTML(val.to_s) ]
end
form << cgi.radio_group("NAME" => "color", "VALUES" => items)
#@ _PRINT_COLOR_RADIO_

form << cgi.p { "As popup menu:" }
#@ _PRINT_COLOR_POPUP_
items = []
values.each do |val|
	items << [ val, CGI.escapeHTML(val.to_s) ]
end
form << cgi.popup_menu("NAME" => "color", "VALUES" => items)
#@ _PRINT_COLOR_POPUP_

form << cgi.p { "As single-pick scrolling list:" }
#@ _PRINT_COLOR_SCROLLING_SINGLE_
# scrolling_list is an alias for popup_menu, but include a SIZE
# value
items = []
values.each do |val|
	items << [ val, CGI.escapeHTML(val.to_s) ]
end
form << cgi.scrolling_list("NAME" => "color", "VALUES" => items, "SIZE" => 3)
#@ _PRINT_COLOR_SCROLLING_SINGLE_

# Add a "Please choose a color" item to head of the list

form << cgi.p { "As popup menu with initial no-choice item:" }
#@ _PLEASE_CHOOSE_COLOR_
items = []
values.each do |val|
	items << [ val, CGI.escapeHTML(val.to_s) ]
end
items.unshift([ "0", "Please choose a color"])
form << cgi.popup_menu("NAME" => "color", "VALUES" => items)
#@ _PLEASE_CHOOSE_COLOR_

# From this point on, we use utility methods for generating radio
# buttons, check boxes, pop-up menus, and scrolling lists.

form << cgi.hr
form << cgi.p { "Cow figurine size:" }

# Retrieve metadata for size column

#@ _FETCH_SIZE_INFO_
size_info = get_enumorset_info(dbh, "cookbook", "cow_order", "size")
#@ _FETCH_SIZE_INFO_

# Use ENUM column information to generate single-pick list elements

form << cgi.p { "As radio button group:" }
#@ _PRINT_SIZE_RADIO_
form << make_radio_group("size",
                         size_info["values"],
                         size_info["values"],
                         size_info["default"],
                         true)    # display items vertically
#@ _PRINT_SIZE_RADIO_

form << cgi.p { "As popup menu:" }
#@ _PRINT_SIZE_POPUP_
form << make_popup_menu("size",
                        size_info["values"],
                        size_info["values"],
                        size_info["default"])
#@ _PRINT_SIZE_POPUP_

form << cgi.p { "As single-pick scrolling list:" }
form << cgi.p { "(skipped; too few items)" }

form << cgi.hr
form << cgi.p { "Cow accessories:" }

# Retrieve metadata for accessory column

#@ _FETCH_ACCESSORY_INFO_
acc_info = get_enumorset_info(dbh, "cookbook", "cow_order", "accessories")
#@ _FETCH_ACCESSORY_INFO_
#@ _SPLIT_ACCESSORY_DEFAULT_
if acc_info["default"].nil?
  acc_def = []
else
  acc_def = acc_info["default"].split(",")
end
#@ _SPLIT_ACCESSORY_DEFAULT_

# Use SET column information to generate multiple-pick list elements

form << cgi.p { "As checkbox group:" }
#@ _PRINT_ACCESSORY_CHECKBOX_
form << make_checkbox_group("accessories",
                            acc_info["values"],
                            acc_info["values"],
                            acc_def,
                            true)      # display items vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

form << cgi.p { "As multiple-pick scrolling list:" }
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_
form << make_scrolling_list("accessories",
                            acc_info["values"],
                            acc_info["values"],
                            acc_def,
                            3,         # display 3 items at a time
                            true)      # create multiple-pick list
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_

form << cgi.hr
form << cgi.p { "State of residence:" }

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
values = []
labels = []
stmt = "SELECT abbrev, name FROM states ORDER BY name"
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    values << row["abbrev"]
    labels << row["name"]
  end
end
#@ _FETCH_STATE_LIST_

# Use state list to generate single-pick form elements

form << cgi.p { "As radio button group:" }
form << cgi.p { "(skipped; too many items)" }

form << cgi.p { "As popup menu:" }
#@ _PRINT_STATE_POPUP_
form << make_popup_menu("state", values, labels, "")
#@ _PRINT_STATE_POPUP_

form << cgi.p { "As single-pick scrolling list:" }
#@ _PRINT_STATE_SCROLLING_SINGLE_
form << make_scrolling_list("state", values, labels, "", 6, false)
#@ _PRINT_STATE_SCROLLING_SINGLE_

# Add a "Please choose a state" item to head of the list

form << cgi.p { "As popup menu with initial no-choice item:" }
#@ _PLEASE_CHOOSE_STATE_
values.unshift("0")
labels.unshift("Please choose a state")
form << make_popup_menu("state", values, labels, "0")
#@ _PLEASE_CHOOSE_STATE_

dbh.disconnect

form = cgi.form("ACTION" => ENV["SCRIPT_NAME"], "METHOD" => "post") {
         form
       }

cgi.out {
  cgi.html {
    cgi.head {
      cgi.title { title }
    } +
    cgi.body() { form }
  }
}
