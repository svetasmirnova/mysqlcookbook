#!/usr/bin/perl
#@ _INITIAL_COMMENT_
# post_image.pl: enable user to upload image files using post requests
#@ _INITIAL_COMMENT_

# This script is a modification of store_image.pl that obtains images over
# the web rather than from the command line.  It stores images only
# in the image table and not in the filesystem.

#@ _MAIN_PROGRAM_
use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;

print header (), start_html (-title => "Post Image");

# Use multipart encoding because the form contains a file upload field

#@ _PRINT_FILE_FORM_
print start_multipart_form (-action => url ()),
      "Image name:", br (),
      textfield (-name =>"image_name", -size => 60),
      br (), "Image file:", br (),
      filefield (-name =>"upload_file", -size => 60),
      br (), br (),
      submit (-name => "choice", -value => "Submit"),
      end_form ();
#@ _PRINT_FILE_FORM_

#@ _PROCESS_UPLOADED_FILE_
# Get a handle to the image file and the name to assign to the image

my $image_file = param ("upload_file");
my $image_name = param ("image_name");

# Must have either no parameters (in which case that script was just
# invoked for the first time) or both parameters (in which case the form
# was filled in).  If only one was filled in, the user did not fill in the
# form completely.

my $param_count = 0;
++$param_count if defined ($image_file) && $image_file ne "";
++$param_count if defined ($image_name) && $image_name ne "";

if ($param_count == 0)      # initial invocation
{
  print p ("No file was uploaded.");
}
elsif ($param_count == 1)   # incomplete form
{
  print p ("Please fill in BOTH fields and resubmit the form.");
}
else                        # a file was uploaded
{
  my ($size, $data);

  # If an image file was uploaded, print some information about it,
  # then save it in the database.

  # Get reference to hash containing information about file
  # and display the information in "key=x, value=y" format
  my $info_ref = uploadInfo ($image_file);
  print p ("Information about uploaded file:");
  foreach my $key (sort (keys (%{$info_ref})))
  {
    print p ("key="
             . escapeHTML ($key)
             . ", value="
             . escapeHTML ($info_ref->{$key}));
  }
  $size = (stat ($image_file))[7]; # get file size from file handle
  print p ("File size: " . $size);

  binmode ($image_file);  # helpful for binary data
  if (sysread ($image_file, $data, $size) != $size)
  {
    print p ("File contents could not be read.");
  }
  else
  {
    print p ("File contents were read without error.");

    # Get MIME type, use generic default if not present

    my $mime_type = $info_ref->{'Content-Type'};
    $mime_type = "application/octet-stream" unless defined ($mime_type);

    # Save image in database table.  (Use REPLACE to kick out any
    # old image that has the same name.)

    my $dbh = Cookbook::connect ();
    $dbh->do ("REPLACE INTO image (name,type,data) VALUES(?,?,?)",
              undef,
              $image_name, $mime_type, $data);
    $dbh->disconnect ();
  }
}

print end_html ();
#@ _MAIN_PROGRAM_
