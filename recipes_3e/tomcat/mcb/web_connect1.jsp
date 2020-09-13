<%@ page import="java.sql.*" %>

<html>
<head><title>Tables in cookbook Database</title></head>
<body>

<p>Tables in cookbook database:</p>

<%
  Connection conn = null;
  String url = "jdbc:mysql://localhost/cookbook";
  String user = "cbuser";
  String password = "cbpass";

  Class.forName ("com.mysql.jdbc.Driver").newInstance ();
  conn = DriverManager.getConnection (url, user, password);

  Statement s = conn.createStatement ();
  s.executeQuery ("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
                  + " WHERE TABLE_SCHEMA = 'cookbook'"
                  + " ORDER BY TABLE_NAME");
  ResultSet rs = s.getResultSet ();
  while (rs.next ())
    out.println (rs.getString (1) + "<br />");
  rs.close ();
  s.close ();
  conn.close ();
%>

</body>
</html>
