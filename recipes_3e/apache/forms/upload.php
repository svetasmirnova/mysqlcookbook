<?php
# upload.php: file upload demonstration

# This script demonstrates how to generate a form that includes a
# file upload field, and how to obtain information about a file and
# read its contents when one is uploaded.  The script does not save
# the file anywhere, so it is discarded when the script exits.

require_once "Cookbook_Webutils.php";

$title = "File Upload Demo";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
if (function_exists ("ini_get"))
{
  $uploads_permitted = (ini_get ("file_uploads") ? "yes" : "no");
  $max_filesize = ini_get ("upload_max_filesize");
  $tmp_dir = ini_get ("upload_tmp_dir");
  print ("file uploads permitted: $uploads_permitted<br />");
  print ("max upload file size: $max_filesize<br />");
  print ("tmp file dir: $tmp_dir<br />");
}

print ("<br />");

# Was a file uploaded?  If so, print some information about it.

#@ _GET_FILE_INFO_
$upload_file = get_upload_info ("upload_file");

if (!$upload_file)
  print ("No file was uploaded<br />");
else
{
  print ("Information about uploaded file:<br />");
    printf ("Temp filename on server: %s<br />",
                htmlspecialchars ($upload_file["tmp_name"]));
    printf ("Filename on client host: %s<br />",
                htmlspecialchars ($upload_file["name"]));
    printf ("File MIME type: %s<br />",
                htmlspecialchars ($upload_file["type"]));
    printf ("File size: %s<br />",
                htmlspecialchars ($upload_file["size"]));
  # try to read file; open in binary mode
  $contents = "";
  if ($fp = fopen ($upload_file["tmp_name"], "rb"))
  {
    $contents = fread ($fp, $upload_file["size"]);
    fclose ($fp);
  }
  if (strlen ($contents) == $upload_file["size"])
    print ("<p>File contents were read without error.</p>");
  else
    print ("<p>File contents could not be read.</p>");
}
#@ _GET_FILE_INFO_
?>

<!-- Display the file upload form -->

<!-- #@ _UPLOAD_FORM_ -->
<form enctype="multipart/form-data" method="post"
    action="<?php print ($_SERVER["PHP_SELF"]); ?>">
<input type="hidden" name="MAX_FILE_SIZE" value="4000000" />
<p>File to upload:</p>
<input type="file" name="upload_file" size="60" />
<br /><br />
<input type="submit" name="choice" value="Submit" />
</form>
<!-- #@ _UPLOAD_FORM_ -->

</body>
</html>
