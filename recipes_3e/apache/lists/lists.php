<?php
# lists.php: generate HTML lists

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Query Output Display - Lists";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
$dbh = Cookbook::connect ();

# Display some lists "manually", printing tags as items are fetched

print ("<p>Ordered list:</p>\n");

#@ _ORDERED_LIST_INTERTWINED_
$stmt = "SELECT item FROM ingredient ORDER BY id";
$sth = $dbh->query ($stmt);
print ("<ol>");
while (list ($item) = $sth->fetch (PDO::FETCH_NUM))
  print ("<li>" . htmlspecialchars ($item) . "</li>");
print ("</ol>");
#@ _ORDERED_LIST_INTERTWINED_

print ("<p>Unordered list:</p>\n");

#@ _UNORDERED_LIST_INTERTWINED_
$stmt = "SELECT item FROM ingredient ORDER BY id";
$sth = $dbh->query ($stmt);
print ("<ul>");
while (list ($item) = $sth->fetch (PDO::FETCH_NUM))
  print ("<li>" . htmlspecialchars ($item) . "</li>");
print ("</ul>");
#@ _UNORDERED_LIST_INTERTWINED_

print ("<p>Definition list:</p>\n");

#@ _DEFINITION_LIST_INTERTWINED_
$stmt = "SELECT note, mnemonic FROM doremi ORDER BY id";
$sth = $dbh->query ($stmt);
print ("<dl>");
while (list ($note, $mnemonic) = $sth->fetch (PDO::FETCH_NUM))
{
  print ("<dt>" . htmlspecialchars ($note) . "</dt>");
  print ("<dd>" . htmlspecialchars ($mnemonic) . "</dd>");
}
print ("</dl>");
#@ _DEFINITION_LIST_INTERTWINED_

# Display some lists using utility functions.

# Fetch items for use with ordered/unordered list functions

#@ _FETCH_ITEM_LIST_
# fetch items for list
$stmt = "SELECT item FROM ingredient ORDER BY id";
$sth = $dbh->query ($stmt);
$items = $sth->fetchAll (PDO::FETCH_COLUMN, 0);
#@ _FETCH_ITEM_LIST_

print ("<p>Ordered list:</p>\n");

#@ _ORDERED_LIST_FUNCTION_
# generate HTML list
print (make_ordered_list ($items));
#@ _ORDERED_LIST_FUNCTION_

print ("<p>Unordered list:</p>\n");

#@ _UNORDERED_LIST_FUNCTION_
# generate HTML list
print (make_unordered_list ($items));
#@ _UNORDERED_LIST_FUNCTION_

# Fetch terms and definitions for a definition list

#@ _FETCH_DEFINITION_LIST_
# fetch items for list
$stmt = "SELECT note, mnemonic FROM doremi ORDER BY id";
$sth = $dbh->query ($stmt);
$terms = array ();
$defs = array ();
while (list ($note, $mnemonic) = $sth->fetch (PDO::FETCH_NUM))
{
  $terms[] = $note;
  $defs[] = $mnemonic;
}
#@ _FETCH_DEFINITION_LIST_

print ("<p>Definition list:</p>\n");

#@ _DEFINITION_LIST_FUNCTION_
# generate HTML list
print (make_definition_list ($terms, $defs));
#@ _DEFINITION_LIST_FUNCTION_

$dbh = NULL;

print ("<p>Ordered and unordered lists from non-database source:</p>\n");

#@ _NON_DB_DATA_SOURCE_
# create items for list
$items = array (
  'Little Jack Horner,',
  'Sat in a corner,',
  'Eating a Christmas pie.',
  'He stuck in his thumb,',
  'And pulled out a plum,',
  'And said, "What a good boy am I."'
);
#@ _NON_DB_DATA_SOURCE_

print (make_ordered_list ($items));
print (make_unordered_list ($items));
?>

</body>
</html>
