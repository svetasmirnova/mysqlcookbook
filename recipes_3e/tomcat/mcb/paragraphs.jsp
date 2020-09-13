<%-- paragraphs.jsp: generate HTML paragraphs --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Query Output Display - Paragraphs"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<%-- generate paragraph text --%>

<%-- #@ _DISPLAY_PARAGRAPH_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT NOW(), VERSION(), DATABASE()
</sql:query>
<c:set var="row" value="${rs.rowsByIndex[0]}"/>
<c:set var="db" value="${row[2]}"/>
<c:if test="${empty db}">
  <c:set var="db" value="NONE"/>
</c:if>

<p>Local time on the server is <c:out value="${row[0]}"/>.</p>
<p>The server version is <c:out value="${row[1]}"/>.</p>
<p>The default database is <c:out value="${db}"/>.</p>
<%-- #@ _DISPLAY_PARAGRAPH_ --%>

</body>
</html>
