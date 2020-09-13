<?php
# show_params.php: print request parameter names and values

require_once "Cookbook_Webutils.php";

$title = "Script Input Parameters";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
error_reporting (E_ALL);

function print_param ($name, $val)
{
  if ($val === NULL)
    $val = "[not set]";
  else if ($val == "")
    $val = "[empty string]";
  else if (!$val)
    $val = "[false]";
  if (is_array ($val))
    $val = "Array(" . implode (", ", $val) . ")";
  print ("$name: " . htmlspecialchars ($val) . "<br />");
}

function print_param_array ($array)
{
  $count = 0;
  foreach ($array as $name => $val)
  {
    print_param ($name, $val);
    ++$count;
  }
  if ($count == 0)
    print ("[none]<br />");
}

print_param ("QUERY_STRING", get_server_val ("QUERY_STRING"));
print_param ("REQUEST_URI", get_server_val ("REQUEST_URI"));
print_param ("SCRIPT_NAME", get_server_val ("SCRIPT_NAME"));
print_param ("PHP_SELF", get_server_val ("PHP_SELF"));

print_param ("get_magic_quotes_gpc ()", get_magic_quotes_gpc ());
print_param ("get_cfg_var (magic_quotes_gpc)", get_cfg_var ("magic_quotes_gpc"));
print_param ("get_cfg_var (register_globals)", get_cfg_var ("register_globals"));

if (function_exists ("ini_get"))
{
  print_param ("ini_get (magic_quotes_gpc)", ini_get ("magic_quotes_gpc"));
  print_param ("ini_get (register_globals)", ini_get ("register_globals"));
  print_param ("ini_get (track_vars)", ini_get ("track_vars"));
}

print ("<hr />Parameters present in \$_GET array:");
print ("<br />");
if ($_GET === NULL)
  print ("array is not set");
else
  print_param_array ($_GET);
print ("<br />");

print ("<hr />Parameters present in \$_POST array:");
print ("<br />");
if ($_POST === NULL)
  print ("array is not set");
else
  print_param_array ($_POST);
print ("<br />");

# Could do $_FILES, but the forms contain no upload fields...

$param_names = get_param_names ();
print ("Parameter names (using get_param_names()): "
       . implode (", ", $param_names));
print ("<br />");
sort ($param_names);
foreach ($param_names as $val)
  print_param ($val, get_param_val ($val));

print ("<br />");

# This example prints just the parameter names without the values

print ("Parameter names (using get_param_names(), but not print_param()): ");
print ("<br />");
#@ _PRINT_PARAM_NAMES_
$param_names = get_param_names ();
foreach ($param_names as $name)
  print (htmlspecialchars ($name) . "<br />");
#@ _PRINT_PARAM_NAMES_

print ("<br />");

# Try a parmameter that (probably) doesn't exist.

print_param ("nonexistent-param", get_param_val ("nonexistent-param"));

$self_path = $_SERVER["PHP_SELF"];
?>

<!--
include forms that can be used to submit requests using get and post
-->

<p>Form 1:</p>

<form method="get" action="<?php print ($self_path); ?>">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color[]" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>

<br />
<input type="submit" name="choice" value="Submit by get">
</form>

<p>Form 2:</p>

<form method="post" action="<?php print ($self_path); ?>">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color[]" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>
<br />

<input type="submit" name="choice" value="Submit by post">
</form>

</body>
</html>
