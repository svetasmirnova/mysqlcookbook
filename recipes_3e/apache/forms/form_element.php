<?php
# form_element.php: generate form elements from database contents

require_once "Cookbook.php";
require_once "Cookbook_Utils.php";
require_once "Cookbook_Webutils.php";

$title = "Form Element Generation";

$dbh = Cookbook::connect ();
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<form action="<?php print ($_SERVER["PHP_SELF"]); ?>" method="post">

<?php
print ("<p>Cow color:</p>\n");

# Retrieve values and labels for color list

#@ _FETCH_COLOR_LIST_
$stmt = "SELECT color FROM cow_color ORDER BY color";
$sth = $dbh->query ($stmt);
$values = $sth->fetchAll (PDO::FETCH_COLUMN, 0);
#@ _FETCH_COLOR_LIST_

# Use color list to generate single-pick form elements

print ("<p>As radio button group:</p>\n");
#@ _PRINT_COLOR_RADIO_
print (make_radio_group ("color", $values, $values, "", TRUE));
#@ _PRINT_COLOR_RADIO_

print ("<p>As popup menu (using fetch-and-print loop):</p>\n");
#@ _FETCH_AND_PRINT_COLOR_LIST_
$stmt = "SELECT color FROM cow_color ORDER BY color";
$sth = $dbh->query ($stmt);
print ('<select name="color">');
while (list ($color) = $sth->fetch (PDO::FETCH_NUM))
{
  $color = htmlspecialchars ($color);
  printf ('<option value="%s">%s</option>', $color, $color);
}
print ("</select>\n");
#@ _FETCH_AND_PRINT_COLOR_LIST_

print ("<p>As popup menu (using utility function):</p>\n");
#@ _PRINT_COLOR_POPUP_
print (make_popup_menu ("color", $values, $values, ""));
#@ _PRINT_COLOR_POPUP_

print ("<p>As single-pick scrolling list:</p>\n");
#@ _PRINT_COLOR_SCROLLING_SINGLE_
print (make_scrolling_list ("color", $values, $values, "", 3, FALSE));
#@ _PRINT_COLOR_SCROLLING_SINGLE_

print ("<hr />\n");
print ("<p>Cow figurine size:</p>\n");

# Retrieve metadata for size column

#@ _FETCH_SIZE_INFO_
$size_info = get_enumorset_info ($dbh, "cookbook", "cow_order", "size");
#@ _FETCH_SIZE_INFO_

# Use ENUM column information to generate single-pick list elements

print ("<p>As radio button group:</p>\n");
#@ _PRINT_SIZE_RADIO_
print (make_radio_group ("size",
                         $size_info["values"],
                         $size_info["values"],
                         $size_info["default"],
                         TRUE));   # display items vertically
#@ _PRINT_SIZE_RADIO_

print ("<p>As popup menu:</p>\n");
#@ _PRINT_SIZE_POPUP_
print (make_popup_menu ("size",
                        $size_info["values"],
                        $size_info["values"],
                        $size_info["default"]));
#@ _PRINT_SIZE_POPUP_

print ("<p>As single-pick scrolling list:</p>\n");
print ("<p>(skipped; too few items)</p>\n");

print ("<hr />\n");
print ("<p>Cow accessories:</p>\n");

# Retrieve metadata for accessory column

#@ _FETCH_ACCESSORY_INFO_
$acc_info = get_enumorset_info ($dbh, "cookbook", "cow_order", "accessories");
#@ _FETCH_ACCESSORY_INFO_
#@ _SPLIT_ACCESSORY_DEFAULT_
$acc_def = explode (",", $acc_info["default"]);
#@ _SPLIT_ACCESSORY_DEFAULT_

# Use SET column information to generate multiple-pick list elements

print ("<p>As checkbox group:</p>\n");
#@ _PRINT_ACCESSORY_CHECKBOX_
print (make_checkbox_group ("accessories[]",
                            $acc_info["values"],
                            $acc_info["values"],
                            $acc_def,
                            TRUE));   # display items vertically
#@ _PRINT_ACCESSORY_CHECKBOX_

print ("<p>As multiple-pick scrolling list:</p>\n");
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_
print (make_scrolling_list ("accessories[]",
                            $acc_info["values"],
                            $acc_info["values"],
                            $acc_def,
                            3,        # display 3 items at a time
                            TRUE));   # create multiple-pick list
#@ _PRINT_ACCESSORY_SCROLLING_MULTIPLE_

print ("<hr />\n");
print ("<p>State of residence:</p>\n");

# Retrieve values and labels for state list

#@ _FETCH_STATE_LIST_
$values = array ();
$labels = array ();
$stmt = "SELECT abbrev, name FROM states ORDER BY name";
$sth = $dbh->query ($stmt);
while ($row = $sth->fetch (PDO::FETCH_NUM))
{
  $values[] = $row[0];
  $labels[] = $row[1];
}
#@ _FETCH_STATE_LIST_

# Use state list to generate single-pick form elements

print ("<p>As radio button group:</p>\n");
print ("<p>(skipped; too many items)</p>\n");

print ("<p>As popup menu (using fetch-and-print loop):</p>\n");
#@ _FETCH_AND_PRINT_STATE_LIST_
$stmt = "SELECT abbrev, name FROM states ORDER BY name";
$sth = $dbh->query ($stmt);
print ('<select name="state">');
while ($row = $sth->fetch (PDO::FETCH_NUM))
{
  $abbrev = htmlspecialchars ($row[0]);
  $name = htmlspecialchars ($row[1]);
  printf ('<option value="%s">%s</option>', $abbrev, $name);
}
print ("</select>");
#@ _FETCH_AND_PRINT_STATE_LIST_

print ("<p>As popup menu (using utility function):</p>\n");
#@ _PRINT_STATE_POPUP_
print (make_popup_menu ("state", $values, $labels, ""));
#@ _PRINT_STATE_POPUP_

print ("<p>As single-pick scrolling list:</p>\n");
#@ _PRINT_STATE_SCROLLING_SINGLE_
print (make_scrolling_list ("state", $values, $labels, "", 6, FALSE));
#@ _PRINT_STATE_SCROLLING_SINGLE_

# Add a "Please choose a state" item to head of the list

print ("<p>As popup menu with initial no-choice item:</p>\n");
#@ _PLEASE_CHOOSE_STATE_
array_unshift ($values, "0");
array_unshift ($labels, "Please choose a state");
print (make_popup_menu ("state", $values, $labels, "0"));
#@ _PLEASE_CHOOSE_STATE_

$dbh = NULL;
?>

</form>

</body>
</html>
