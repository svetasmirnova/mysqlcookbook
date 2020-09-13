<%--
  Use JSTL SQL <sql:setDataSource> tag to set up a connection to
  MySQL and make it available in a variable "conn".  This can be used
  as the dataSource attribute in other JSTL sql tags.
--%>

<%-- _MAIN_ --%>
<sql:setDataSource
  var="conn"
  driver="com.mysql.jdbc.Driver"
  url="jdbc:mysql://localhost/cookbook"
  user="cbuser"
  password="cbpass"
/>
<%-- _MAIN_ --%>
