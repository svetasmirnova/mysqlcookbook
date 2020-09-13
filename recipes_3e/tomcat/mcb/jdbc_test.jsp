<%--
  jdbc_test.jsp: test page for verifying that Tomcat finds the JDBC driver
  (edit the connection parameters if necessary)
--%>
<%@ page import="java.sql.*" %>

<html>
<head><title>JDBC Test Page</title></head>
<body>

<%
  Connection conn = null;
  String url = "jdbc:mysql://localhost/cookbook";
  String user = "cbuser";
  String password = "cbpass";

  Class.forName ("com.mysql.jdbc.Driver").newInstance ();
  conn = DriverManager.getConnection (url, user, password);

  Statement s = conn.createStatement ();
  s.executeQuery ("SELECT NOW(), VERSION()");
  ResultSet rs = s.getResultSet ();
  if (rs.next ())
  {
    out.println ("Current time: " + rs.getString (1) + "<br />");
    out.println ("MySQL server version: " + rs.getString (2) + "<br />");
  }
  rs.close ();
  s.close ();
  conn.close ();
%>

</body>
</html>
