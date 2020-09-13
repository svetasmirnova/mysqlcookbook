<%-- scope.jsp: simple demonstration of scope attribute set/get methods --%>

<html>
<head><title>Simple Scope Test</title></head>
<body>

<p>Storing value "tomcat.example.com" in request scope attribute "myhost"...</p>

// #@ _REQUEST_SET_ATTRIBUTE_
<% request.setAttribute ("myhost", "tomcat.example.com"); %>
// #@ _REQUEST_SET_ATTRIBUTE_

<p>Done.</p>

<p>Fetching value of "myhost" attribute...</p>

// #@ _REQUEST_GET_ATTRIBUTE_
<%
  Object obj = request.getAttribute ("myhost");
  String host = obj.toString ();
%>
// #@ _REQUEST_GET_ATTRIBUTE_

<p>Done.</p>

<% out.println ("myhost value = " + host); %>

<p>Repeating operation using
pageContext.xxxAttribute(..., REQUEST_SCOPE)...</p>

// #@ _PAGE_SETGET_ATTRIBUTE_
<%
  pageContext.setAttribute ("myhost", "tomcat.example.com",
                            pageContext.REQUEST_SCOPE);
  obj = pageContext.getAttribute ("myhost", pageContext.REQUEST_SCOPE);
  host = obj.toString ();
%>
// #@ _PAGE_SETGET_ATTRIBUTE_

<p>Done.</p>

<p>Fetching value of "myhost" attribute...</p>

<% out.println ("myhost value = " + host); %>

</body>
</html>
