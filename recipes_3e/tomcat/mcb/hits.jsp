<%-- hits.jsp --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Hit Count Example"/>

<c:set var="selfPath"><%= request.getRequestURI () %></c:set>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<p>Page path: <c:out value="${selfPath}"/></p>

<%-- update counter --%>

<%--
  The queries here are grouped within a <sql:transaction> tag to
  guarantee that the query that generates the AUTO_INCREMENT value
  and the query that retrieves it use the same connection.  Otherwise,
  JSTL may use a separate connection for each query.
--%>

<sql:transaction dataSource="${conn}">
  <sql:update var="rowCount">
    INSERT INTO hitcount (path,hits) VALUES(?,LAST_INSERT_ID(1))
     ON DUPLICATE KEY UPDATE hits = LAST_INSERT_ID(hits+1)
    <sql:param value="${selfPath}"/>
  </sql:update>
  <sql:query var="rs">
    SELECT LAST_INSERT_ID()
  </sql:query>
  <c:set var="count" value="${rs.rowsByIndex[0][0]}"/>
</sql:transaction>

<%-- print current counter value --%>

<p>
This page has been accessed
<c:out value="${count}"/>
times.
</p>

<%--
  Use a logging approach to hit recording.  This enables
  the most recent hits to be displayed.
--%>

<%-- _LOG_HIT_ --%>
<c:set var="host"><%= request.getRemoteHost () %></c:set>
<c:if test="${empty host}">
  <c:set var="host"><%= request.getRemoteAddr () %></c:set>
</c:if>
<c:if test="${empty host}">
  <c:set var="host">UNKNOWN</c:set>
</c:if>

<sql:update dataSource="${conn}">
  INSERT INTO hitlog (path, host) VALUES(?,?)
  <sql:param><%= request.getRequestURI () %></sql:param>
  <sql:param value="${host}"/>
</sql:update>
<%-- _LOG_HIT_ --%>

<%-- Display the most recent hits for the page --%>

<p>Most recent hits:</p>
<table border="1">
  <tr>
    <th>Date</th>
    <th>Host</th>
  </tr>

<sql:query dataSource="${conn}" var="rs">
  SELECT DATE_FORMAT(t, '%Y-%m-%d %T') AS date, host
  FROM hitlog
  WHERE path = ? ORDER BY date DESC LIMIT 10
  <sql:param><%= request.getRequestURI () %></sql:param>
</sql:query>

<c:forEach items="${rs.rows}" var="row">
  <tr>
    <td><c:out value="${row.date}"/></td>
    <td><c:out value="${row.host}"/></td>
  </tr>
</c:forEach>

</table>

</body>
</html>
