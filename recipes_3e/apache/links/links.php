<?php
# links.php: generate HTML hyperlinks

require_once "Cookbook.php";
require_once "Cookbook_Webutils.php";

$title = "Query Output Display - Hyperlinks";
?>

<html>
<head><title><?php print ($title); ?></title></head>
<body>

<?php
$dbh = Cookbook::connect ();

print ("<p>Book vendors as static text:</p>\n");
#@ _DISPLAY_STATIC_URL_
$stmt = "SELECT name, website FROM book_vendor ORDER BY name";
$sth = $dbh->query ($stmt);
$items = array ();
while (list ($name, $website) = $sth->fetch (PDO::FETCH_NUM))
  $items[] = "Vendor: $name, website: http://$website";
print (make_unordered_list ($items));
#@ _DISPLAY_STATIC_URL_

print ("<p>Book vendors as hyperlinks:</p>\n");
#@ _DISPLAY_HYPERLINK_URL_
$stmt = "SELECT name, website FROM book_vendor ORDER BY name";
$sth = $dbh->query ($stmt);
$items = array ();
while (list ($name, $website) = $sth->fetch (PDO::FETCH_NUM))
{
  $items[] = sprintf ('<a href="http://%s">%s</a>',
                      $website, htmlspecialchars ($name));
}

# don't encode the items, they're already encoded
print (make_unordered_list ($items, 0));
#@ _DISPLAY_HYPERLINK_URL_

print ("<p>Email directory:</p>\n");
#@ _DISPLAY_EMAIL_LIST_
$stmt = "SELECT department, name, email
          FROM newsstaff
          ORDER BY department, name";
$sth = $dbh->query ($stmt);
$items = array ();
while (list ($dept, $name, $email) = $sth->fetch (PDO::FETCH_NUM))
{
  $items[] = htmlspecialchars ($dept)
              . ": "
              .  make_email_link ($name, $email);
}

# don't encode the items, they're already encoded
print (make_unordered_list ($items, 0));
#@ _DISPLAY_EMAIL_LIST_

print ("<p>Some sample invocations of make_email_link():</p>\n");
print ("<p>Name + address: "
    . make_email_link ("Rex Conex", "rconex@wrrr-news.com")
    . "</p>");
print ("<p>Name + unset address: "
    . make_email_link ("Rex Conex", NULL)
    . "</p>");
print ("<p>Name + empty string address: "
    . make_email_link ("Rex Conex", "")
    . "</p>");
print ("<p>Name + missing address: "
    . make_email_link ("Rex Conex")
    . "</p>");
print ("<p>Address as name: "
    . make_email_link ("rconex@wrrr-news.com", "rconex@wrrr-news.com")
    . "</p>");

$dbh = NULL;
?>

</body>
</html>
