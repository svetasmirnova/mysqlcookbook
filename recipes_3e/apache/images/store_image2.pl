#!/usr/bin/perl
#@ _INITIAL_COMMENT_
# store_image2.pl: just like store_image.pl (which see), except
# that it constructs the REPLACE query by escaping the data values
# and inserts them literally into the query string.
#@ _INITIAL_COMMENT_

# *** BEFORE USING: make sure to set $image_dir appropriately ***

# Note that this script makes no assumptions about the form of the image
# file, so in fact it really works on arbitrary files, no matter what
# they contain.  But it's up to you to specify the correct mime-type
# argument.

# Uses file basename for name column value if no name was given.

#@ _MAIN_PROGRAM_
use strict;
use warnings;
use Fcntl;    # for O_RDONLY, O_WRONLY, O_CREAT
use FileHandle;
use Cookbook;

# Default image storage directory and pathname separator
# *** (CHANGE THESE AS NECESSARY) ***
# The location should NOT be within the web server document tree
my $image_dir = "/usr/local/lib/mcb/images";
my $path_sep = "/";

# Reset directory and pathname separator for Windows/DOS
if ($^O =~ /^MSWin/i || $^O =~ /^dos/)
{
  $image_dir = "C:\\mcb\\images";
  $path_sep = "\\";
}

-d $image_dir or die "$0: image directory ($image_dir)\ndoes not exist\n";

# Print help message if script was not invoked properly

(@ARGV == 2 || @ARGV == 3) or die <<USAGE_MESSAGE;
Usage: $0 image_file mime_type [image_name]

image_file = name of the image file to store
mime_time = the image MIME type (e.g., image/jpeg or image/png)
image_name = alternate name to give the image

image_name is optional; if not specified, the default is the
image file basename.
USAGE_MESSAGE

my $file_name = shift (@ARGV);  # image filename
my $mime_type = shift (@ARGV);  # image MIME type
my $image_name = shift (@ARGV); # image name (optional)

# if image name was not specified, use filename basename
# (permit either / or \ as separator)
($image_name = $file_name) =~ s|.*[/\\]|| unless defined ($image_name);

my $fh = new FileHandle;
my ($size, $data);

sysopen ($fh, $file_name, O_RDONLY)
  or die "Cannot read $file_name: $!\n";
binmode ($fh);    # helpful for binary data
$size = (stat ($fh))[7];
sysread ($fh, $data, $size) == $size
  or die "Failed to read entire file $file_name: $!\n";
$fh->close ();

# Save image file in filesystem under $image_dir.  (Overwrite file
# if an old version exists.)

my $image_path = $image_dir . $path_sep . $image_name;

sysopen ($fh, $image_path, O_WRONLY|O_CREAT)
  or die "Cannot open $image_path: $!\n";
binmode ($fh);    # helpful for binary data
syswrite ($fh, $data, $size) == $size
  or die "Failed to write entire image file $image_path: $!\n";
$fh->close ();

# Save image in database table.  (Use REPLACE to kick out any old image
# that has the same name.)

my $dbh = Cookbook::connect ();
#@ _REPLACE_
$image_name = $dbh->quote ($image_name);
$mime_type = $dbh->quote ($mime_type);
$data = $dbh->quote ($data);
$dbh->do ("REPLACE INTO image (name,type,data)
           VALUES($image_name,$mime_type,$data)");
#@ _REPLACE_
$dbh->disconnect ();
#@ _MAIN_PROGRAM_
