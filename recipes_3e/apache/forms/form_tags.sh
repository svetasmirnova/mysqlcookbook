#!/bin/sh
# form_tags.sh: generate form tags in various APIs

# These are illustrative only.  They don't really run correctly
# in a non-Web environment, because the request self-URI isn't
# available.

perl << 'EOF'
use strict;
use CGI qw(:standard);
#@ _PERL_FORM_
print start_form (-action => url (), -method => "post");
# ... generate form elements here ...
print end_form ();
#@ _PERL_FORM_
EOF

echo ""

ruby << 'EOF'
require "cgi"

# set up fake name so next part works from command line
ENV["SCRIPT_NAME"] = "myscript.rb"

cgi = CGI.new("html4")

#@ _RUBY_FORM_
cgi.out {
  cgi.form("action" => ENV["SCRIPT_NAME"], "method" => "post") {
    # ... generate form elements here ...
  }
}
#@ _RUBY_FORM_
EOF

echo ""

php << 'EOF'
<?php
# set up fake name so next part works from command line
$_SERVER['PHP_SELF'] = 'myscript.php';

#@ _PHP_FORM_
print ('<form action="' . $_SERVER['PHP_SELF'] . '" method="post">');
# ... generate form elements here ...
print ('</form>');
#@ _PHP_FORM_
EOF

echo ""

python << 'EOF'
import os
# assign value to prevent exception when value is accessed in non-CGI
# environment...
os.environ['SCRIPT_NAME'] = 'myscript.py'

#@ _PYTHON_FORM_
print('<form action="%s" method="post">' % os.environ['SCRIPT_NAME'])
# ... generate form elements here ...
print('</form>')
#@ _PYTHON_FORM_
EOF

echo ""

cat << 'EOF'
<%-- #@ _JSP_FORM_ --%>
<form action="<%= request.getRequestURI () %>" method="post">
<%-- ... generate form elements here ... --%>
</form>
<%-- #@ _JSP_FORM_ --%>
EOF
