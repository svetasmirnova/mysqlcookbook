<?php
# post_image.php: enable user to upload image files using post requests

require_once "Cookbook.php";
require_once "Cookbook_Utils.php";
require_once "Cookbook_Webutils.php";

$title = "Post Image";
?>

<html>
<head><title><?php print ($title); ?></title><body>

<!-- Display the file upload form -->
<!-- Use multipart encoding because the form contains a file upload field -->

<!-- #@ _PRINT_FILE_FORM_ -->
<form method="post" enctype="multipart/form-data"
  action="<?php print ($_SERVER["PHP_SELF"]); ?>">
<input type="hidden" name="MAX_FILE_SIZE" value="4000000" />
Image name:<br />
<input type="text" name="image_name" size="60" />
<br />
Image file:<br />
<input type="file" name="upload_file" size="60" />
<br /><br />
<input type="submit" name="choice" value="Submit" />
</form>
<!-- #@ _PRINT_FILE_FORM_ -->

<?php
# Get info for the uploaded image file and the name to assign to the image

$image_file = get_upload_info ("upload_file");
$image_name = get_param_val ("image_name");

# Must have either no parameters (in which case that script was just
# invoked for the first time) or both parameters (in which case the form
# was filled in).  If only one was filled in, the user did not fill in the
# form completely.

$param_count = 0;
if (isset ($image_file))
  ++$param_count;
if (isset ($image_name) && $image_name != "")
  ++$param_count;

if ($param_count == 0)      # initial invocation
{
  print ("<p>No file was uploaded.</p>");
}
else if ($param_count == 1)   # incomplete form
{
  print ("<p>Please fill in BOTH fields and resubmit the form.</p>");
}
else              # a file was uploaded
{
  # If an image file was uploaded, print some information about it,
  # then save it in the database.

  print ("<p>Information about uploaded file:</p>");
  print ("Filename on client side: " . $image_file["name"] . "<br />");
  print ("Temp filename: " . $image_file["tmp_name"] . "<br />");
  print ("MIME type: " . $image_file["type"] . "<br />");
  print ("File size: " . $image_file["size"] . "<br />");

  # Try to read file; open in binary mode

  $data = "";
  if ($fp = fopen ($image_file["tmp_name"], "rb"))
  {
    $data = fread ($fp, $image_file["size"]);
    fclose ($fp);
  }
  if (strlen ($data) != $image_file["size"])
  {
    print ("<p>File contents could not be read.</p>");
  }
  else
  {
    print ("<p>File contents were read without error.</p>");

    # Get MIME type, use generic default if not present

    $mime_type = $image_file["type"];
    if (!isset ($mime_type) || $mime_type == "")
      $mime_type = "application/octet-stream";

    # Save image in database table.  (Use REPLACE to kick out any
    # old image that has the same name.)

    $dbh = Cookbook::connect ();
    $stmt = "REPLACE INTO image (name,type,data) VALUES(?,?,?)";
    $values = array ($image_name, $mime_type, $data);
    $sth = $dbh->prepare ($stmt);
    $sth->execute ($values);
    $dbh = NULL;
  }
}
?>

</body>
</html>
