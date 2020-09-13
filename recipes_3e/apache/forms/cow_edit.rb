#!/usr/bin/ruby
# cow_edit.pl: Present a form for editing a record in the cow_order table.
# (Display only; does not actually process submitted contents.)

# Form has fields that are initialized to the column values from a record
# in the table.  (The script uses record 1.)

require "cgi"
require "Cookbook"
require "Cookbook_Utils"
require "Cookbook_Webutils"

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

self_path = ENV["SCRIPT_NAME"] || $0

title = "Cow Figurine Order Record Editing Form"

cgi = CGI.new("html4")
page = ""

dbh = Cookbook.connect

# Retrieve a record by ID from the cow_order table

#@ _FETCH_ORDER_INFO_
id = 1      # select record number 1
color = nil
color, size, accessories, cust_name, cust_street, cust_city, cust_state =
  dbh.select_one(
                "SELECT
                   color, size, accessories,
                   cust_name, cust_street, cust_city, cust_state
                 FROM cow_order WHERE id = ?",
                id)
#@ _FETCH_ORDER_INFO_
if color.nil?
  cgi.out {
    cgi.html {
      cgi.head {
        cgi.title { title }
      } +
      cgi.body() {
        cgi.p { "No cow_order record for id #{id} was found." }
      }
    }
  }
  exit(0)
end

page << cgi.p { "Values to be loaded into form:" }
page << cgi.ul {
  cgi.li { CGI.escapeHTML("id = #{id} (this is a hidden field;" +
             " use 'show source' to see it)") } +
  cgi.li { CGI.escapeHTML("color = #{color}") } +
  cgi.li { CGI.escapeHTML("size = #{size}") } +
  cgi.li { CGI.escapeHTML("accessories = #{accessories}") } +
  cgi.li { CGI.escapeHTML("name = #{cust_name}") } +
  cgi.li { CGI.escapeHTML("street = #{cust_street}") } +
  cgi.li { CGI.escapeHTML("city = #{cust_city}") } +
  cgi.li { CGI.escapeHTML("state = #{cust_state}") }
}

#@ _SPLIT_ACCESSORY_VALUE_
if accessories.nil?
  acc_val = []
else
  acc_val = accessories.split(",")
end
#@ _SPLIT_ACCESSORY_VALUE_

# Retrieve values for color list

#@ _FETCH_COLOR_LIST_
color_values = []
stmt = "SELECT color FROM cow_color ORDER BY color"
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    color_values << row["color"]
  end
end
#@ _FETCH_COLOR_LIST_

# Retrieve metadata for size and accessory columns

#@ _FETCH_SIZE_INFO_
size_info = get_enumorset_info(dbh, "cookbook", "cow_order", "size")
#@ _FETCH_SIZE_INFO_
#@ _FETCH_ACCESSORY_INFO_
acc_info = get_enumorset_info(dbh, "cookbook", "cow_order", "accessories")
#@ _FETCH_ACCESSORY_INFO_

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
state_values = []
state_labels = []
stmt = "SELECT abbrev, name FROM states ORDER BY name"
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    state_values << row["abbrev"]
    state_labels << row["name"]
  end
end
#@ _FETCH_STATE_LIST_

dbh.disconnect

# Generate various types of form elements, using the cow_order record
# to provide the default value for each element.

form = ""

# Put ID value into a hidden field

#@ _PRINT_ID_HIDDEN_
form << cgi.hidden("NAME" => "id", "VALUE" => id.to_s)
#@ _PRINT_ID_HIDDEN_

# Use color list to generate a pop-up menu

#@ _PRINT_COLOR_POPUP_
form << cgi.br + "Cow color:" + cgi.br
form << make_popup_menu("color", color_values, color_values, color)
#@ _PRINT_COLOR_POPUP_

# Use size column ENUM information to generate radio buttons

#@ _PRINT_SIZE_RADIO_
form << cgi.br + "Cow figurine size:" + cgi.br
form << make_radio_group("size",
                         size_info["values"],
                         size_info["values"],
                         size,
                         true)      # display items vertically
#@ _PRINT_SIZE_RADIO_

# Use accessory column SET information to generate checkboxes

#@ _PRINT_ACCESSORY_CHECKBOX_
form << cgi.br + "Cow accessory items:" + cgi.br
form << make_checkbox_group("accessories[]",
                            acc_info["values"],
                            acc_info["values"],
                            acc_val,
                            true)     # display items vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

#@ _PRINT_CUST_NAME_TEXT_
form << cgi.br + "Customer name:" + cgi.br
form << cgi.text_field("NAME" => "cust_name",
                       "VALUE" => cust_name,
                       "SIZE" => "60")
#@ _PRINT_CUST_NAME_TEXT_

#@ _PRINT_CUST_STREET_TEXT_
form << cgi.br + "Customer street address:" + cgi.br
form << cgi.text_field("NAME" => "cust_street",
                       "VALUE" => cust_street,
                       "SIZE" => "60")
#@ _PRINT_CUST_STREET_TEXT_

#@ _PRINT_CUST_CITY_TEXT_
form << cgi.br + "Customer city:" + cgi.br
form << cgi.text_field("NAME" => "cust_city",
                       "VALUE" => cust_city,
                       "SIZE" => "60")
#@ _PRINT_CUST_CITY_TEXT_

#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_
form << cgi.br + "Customer state:" + cgi.br
form << make_scrolling_list("cust_state",
                            state_values,
                            state_labels,
                            cust_state,
                            6,        # display 6 items at a time
                            false)    # create single-pick list
#@ _PRINT_CUST_STATE_SCROLLING_SINGLE_

form << cgi.br
form << cgi.submit("NAME" => "choice", "VALUE" => "Submit form")

page << cgi.form("ACTION" => self_path, "METHOD" => "post") { form }

cgi.out {
  cgi.html {
    cgi.head {
      cgi.title { title }
    } +
    cgi.body() { page }
  }
}
