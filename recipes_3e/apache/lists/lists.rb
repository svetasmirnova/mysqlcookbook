#!/usr/bin/ruby
# lists.rb: generate HTML lists

require "cgi"
require "Cookbook"
require "Cookbook_Webutils"

title = "Query Output Display - Lists"

cgi = CGI.new("html4")
page = ""

dbh = Cookbook.connect

# Display some lists "manually", generating tags as items are fetched

page << cgi.p { "Ordered list:" }
#@ _ORDERED_LIST_INTERTWINED_
stmt = "SELECT item FROM ingredient ORDER BY id"
list = ""
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    list << cgi.li { CGI.escapeHTML(row["item"].to_s) }
  end
end
list = cgi.ol { list }
#@ _ORDERED_LIST_INTERTWINED_
page << list

page << cgi.p { "Unordered list:" }
#@ _UNORDERED_LIST_INTERTWINED_
stmt = "SELECT item FROM ingredient ORDER BY id"
list = ""
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    list << cgi.li { CGI.escapeHTML(row["item"].to_s) }
  end
end
list = cgi.ul { list }
#@ _UNORDERED_LIST_INTERTWINED_
page << list

page << cgi.p { "Definition list:" }
#@ _DEFINITION_LIST_INTERTWINED_
stmt = "SELECT note, mnemonic FROM doremi ORDER BY id"
list = ""
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    list << cgi.dt { CGI.escapeHTML(row["note"].to_s) }
    list << cgi.dd { CGI.escapeHTML(row["mnemonic"].to_s) }
  end
end
list = cgi.dl { list }
#@ _DEFINITION_LIST_INTERTWINED_
page << list

# Display some lists using pre-fetched items

# Fetch items for use with ordered/unordered list functions

#@ _FETCH_ITEM_LIST_
# fetch items for list
stmt = "SELECT item FROM ingredient ORDER BY id"
items = dbh.select_all(stmt)
#@ _FETCH_ITEM_LIST_

page << cgi.p { "Ordered list:" }
#@ _ORDERED_LIST_DECOUPLED_
list = cgi.ol {
  items.collect { |item| cgi.li { CGI.escapeHTML(item.to_s) } }
}
#@ _ORDERED_LIST_DECOUPLED_
page << list

page << cgi.p { "Ordered list (using utility method):" }
page << make_ordered_list(items)

page << cgi.p { "Unordered list:" }
#@ _UNORDERED_LIST_DECOUPLED_
list = cgi.ul {
  items.collect { |item| cgi.li { CGI.escapeHTML(item.to_s) } }
}
#@ _UNORDERED_LIST_DECOUPLED_
page << list

page << cgi.p { "Unordered list (using utility method):" }
page << make_unordered_list(items)

# Fetch terms and definitions for a definition list

#@ _FETCH_DEFINITION_LIST_
# fetch items for list
stmt = "SELECT note, mnemonic FROM doremi ORDER BY id"
terms = []
definitions = []
dbh.execute(stmt) do |sth|
  sth.fetch do |row|
    terms << row["note"]
    definitions << row["mnemonic"]
  end
end
#@ _FETCH_DEFINITION_LIST_

page << cgi.p { "Definition list:" }
#@ _DEFINITION_LIST_DECOUPLED_
list = ""
for i in 0...terms.length
  list << cgi.dt { CGI.escapeHTML(terms[i].to_s) }
  list << cgi.dd { CGI.escapeHTML(definitions[i].to_s) }
end
list = cgi.dl { list }
#@ _DEFINITION_LIST_DECOUPLED_
page << list

page << cgi.p { "Definition list (using utility method):" }
page << make_definition_list(terms, definitions)

page << cgi.p { "Unmarked list:" }
# fetch items for list
stmt = "SELECT item FROM ingredient ORDER BY id"
items = dbh.select_all(stmt)
#@ _UNMARKED_LIST_DECOUPLED_
list = items.collect { |item| CGI.escapeHTML(item.to_s) + cgi.br }.join
#@ _UNMARKED_LIST_DECOUPLED_
page << list

dbh.disconnect

cgi.out {
  cgi.html {
    cgi.head {
      cgi.title { title }
    } +
    cgi.body() { page }
  }
}
