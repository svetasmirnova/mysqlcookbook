#!/usr/bin/ruby
# show_params.rb: print request parameter names and values

require "cgi"

title = "Script Input Parameters"

cgi = CGI.new("html4")
page = ""

page << cgi.p { "Parameters from cgi object:" }

#@ _DISPLAY_PARAMS_
#@ _GET_PARAM_NAMES_
params = cgi.params
param_names = cgi.params.keys
#@ _GET_PARAM_NAMES_
param_names.sort!
page << cgi.p { "Parameter names:" + param_names.join(", ") }

list = ""
param_names.each do |name|
  val = params[name]
  list << cgi.li {
    "type=#{val.class}, name=#{name}, value=" +
    CGI.escapeHTML(val.join(", "))
  }
end
page << cgi.ul { list }
#@ _DISPLAY_PARAMS_

# include forms that can be sent using get or post

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

self_path = ENV["SCRIPT_NAME"] || $0

page << cgi.p { "Form 1:" }

colors = [ "red", "white", "blue", "black", "silver" ]

form = cgi.form("ACTION" => self_path, "METHOD" => "get") {
         "Enter a text value:" +
         cgi.text_field("NAME" => "text_field", "SIZE" => "60") +
         cgi.br +
         cgi.scrolling_list("NAME" => "color",
                            "VALUES" => colors,
                            "MULTIPLE" => true) +
         cgi.br +
         cgi.submit("NAME" => "choice", "VALUE" => "Submit by get")
       }

page << form

page << cgi.p { "Form 2:" }

form = cgi.form("ACTION" => self_path, "METHOD" => "post") {
         "Enter a text value:" +
         cgi.text_field("NAME" => "text_field", "SIZE" => "60") +
         cgi.br +
         cgi.scrolling_list("NAME" => "color",
                            "VALUES" => colors,
                            "MULTIPLE" => true) +
         cgi.br +
         cgi.submit("NAME" => "choice", "VALUE" => "Submit by post")
       }

page << form

cgi.out {
CGI.pretty(
  cgi.html {
    cgi.head {
      cgi.title { title }
    } +
    cgi.body() { page }
  }
)
}
