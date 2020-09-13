#!/usr/bin/perl
# upload.pl: file upload demonstration

# This script demonstrates how to generate a form that includes a
# file upload field, and how to obtain information about a file and
# read its contents when one is uploaded.  The script does not save
# the file anywhere, so it is discarded when the script exits.

use strict;
use warnings;
use CGI qw(:standard escapeHTML);

my $title = "File Upload Demo";

print header (), start_html (-title => $title);

# Was a file uploaded?  If so, print some information about it.
# The script doesn't save the file; it will be discarded when the
# script exits.

#@ _GET_FILE_INFO_
my $file = param ("upload_file"); # get handle to file

if (defined ($file) && $file ne "") # a file was uploaded
{
my $info_ref = uploadInfo ($file);  # reference to hash of file info
my ($size, $data);

  # Print file attributes in "key=x, value=y" format
  print p ("Uploaded file information:");
  foreach my $key (sort (keys (%{$info_ref})))
  {
    print p ("key="
             . escapeHTML ($key)
             . ", value="
             . escapeHTML ($info_ref->{$key}));
  }
  $size = (stat ($file))[7];  # get file size from file handle
  print p ("File size: " . $size);

  if (sysread ($file, $data, $size) == $size)
  {
    print p ("File contents were read without error.");
  }
  else
  {
    print p ("File contents could not be read.");
  }
}
#@ _GET_FILE_INFO_

print "\n";

# Print a form with a file upload field.  Show different ways to
# specify the encoding type.  Doesn't matter which form you
# use to upload files.

#@ _USE_MULTIPART_LITERAL_
print start_form (-action => url (), -enctype => "multipart/form-data");
#@ _USE_MULTIPART_LITERAL_
print p ("File to upload:");
#@ _PRINT_FILE_FIELD_
print filefield (-name =>"upload_file", -size => 60);
#@ _PRINT_FILE_FIELD_
print br (), br ();
print submit (-name => "choice", -value => "Submit");
print end_form ();
print "\n";

#@ _USE_MULTIPART_FUNCTION_
print start_form (-action => url (), -enctype => MULTIPART ());
#@ _USE_MULTIPART_FUNCTION_
print p ("File to upload:");
print filefield (-name =>"upload_file", -size => 60);
print br (), br ();
print submit (-name => "choice", -value => "Submit");
print end_form ();
print "\n";

#@ _SIMPLE_UPLOAD_FORM_
#@ _USE_START_MULTIPART_FORM_
print start_multipart_form (-action => url ());
#@ _USE_START_MULTIPART_FORM_
print p ("File to upload:");
print filefield (-name =>"upload_file", -size => 60);
print br (), br ();
print submit (-name => "choice", -value => "Submit");
print end_form ();
#@ _SIMPLE_UPLOAD_FORM_
