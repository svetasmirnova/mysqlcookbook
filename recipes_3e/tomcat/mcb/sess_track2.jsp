<%--
  sess_track2.jsp: session request counting/timestamping demonstration
--%>

<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.count}">
  <c:set var="count" scope="session" value="0"/>
</c:if>
<c:set var="count" scope="session" value="${sessionScope.count+1}"/>

<%
  ArrayList timestamp = (ArrayList) session.getAttribute ("timestamp");
  if (timestamp == null)
    timestamp = new ArrayList ();
  // add current timestamp to timestamp array, store result in session
  timestamp.add (new Date ());
  session.setAttribute ("timestamp", timestamp);
%>

<html>
<head><title>JSP Session Tracker</title></head>
<body>

<p>This session has been active for
<c:out value="${sessionScope.count}"/>
requests.</p>
<p>The requests occurred at these times:</p>
<ol>
<c:forEach items="${sessionScope.timestamp}" var="t">
  <li><c:out value="${t}"/></li>
</c:forEach>
</ol>
<p>Reload page to send next request.</p>

<%-- has session limit of 10 requests been reached? --%>

<c:if test="${sessionScope.count ge 10}">
  <c:remove var="count" scope="session"/>
  <c:remove var="timestamp" scope="session"/>
</c:if>

</body>
</html>
