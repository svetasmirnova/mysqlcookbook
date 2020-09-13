#!/usr/bin/perl
#@ _INITIAL_COMMENT_
# display_image.pl: display image over the Web
#@ _INITIAL_COMMENT_

# *** BEFORE USING: make sure to set $imagedir appropriately ***

# URL parameters:
# name = image name (required)
# location = data location (optional)
# Whether to serve image from image database table or from the filesystem.
# Values: db, fs (default db).

#@ _MAIN_PROGRAM_
use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use FileHandle;
use Cookbook;

sub error
{
my $msg = escapeHTML ($_[0]);

  print header (), start_html ("Error"), p ($msg), end_html ();
  exit (0);
}

# Default image storage directory and pathname separator
# *** (CHANGE THESE AS NECESSARY) ***
my $image_dir = "/usr/local/lib/mcb/images";
# The location should NOT be within the web server document tree
my $path_sep = "/";

# Reset directory and pathname separator for Windows/DOS
if ($^O =~ /^MSWin/i || $^O =~ /^dos/)
{
  $image_dir = "C:\\mcb\\images";
  $path_sep = "\\";
}

my $name = param ("name");
my $location = param ("location");

# make sure image name was specified
defined ($name) or error ("image name is missing");
# use default of "db" if the location is not specified or is
# not "db" or "fs"
(defined ($location) && $location eq "fs") or $location = "db";

my $dbh = Cookbook::connect ();

my ($type, $data);

# If location is "db", get image data and MIME type from image table.
# If location is "fs", get MIME type from image table and read the image
# data from the filesystem.

if ($location eq "db")
{
  ($type, $data) = $dbh->selectrow_array (
                          "SELECT type, data FROM image WHERE name = ?",
                          undef,
                          $name)
        or error ("Cannot find image with name $name");
}
else
{
  $type = $dbh->selectrow_array (
                          "SELECT type FROM image WHERE name = ?",
                          undef,
                          $name)
        or error ("Cannot find image with name $name");
  my $fh = new FileHandle;
  my $image_path = $image_dir . $path_sep . $name;
  open ($fh, $image_path)
    or error ("Cannot read $image_path: $!");
  binmode ($fh);    # helpful for binary data
  my $size = (stat ($fh))[7];
  read ($fh, $data, $size) == $size
    or error ("Failed to read entire file $image_path: $!");
  $fh->close ();
}

$dbh->disconnect ();

# Send image to client, preceded by Content-Type: and Content-Length:
# headers.

print header (-type => $type, -Content_Length => length ($data));
print $data;
#@ _MAIN_PROGRAM_
