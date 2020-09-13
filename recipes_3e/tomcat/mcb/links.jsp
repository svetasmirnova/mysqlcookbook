<%-- links.jsp: generate HTML hyperlinks --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Query Output Display - Links"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<p>
Book vendors as static text:
</p>

<%-- _DISPLAY_STATIC_URL_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT name, website FROM book_vendor ORDER BY name
</sql:query>

<ul>
<c:forEach items="${rs.rows}" var="row">
  <li>
    Vendor: <c:out value="${row.name}"/>,
    Website: <c:out value="${row.website}"/>
  </li>
</c:forEach>
</ul>
<%-- _DISPLAY_STATIC_URL_ --%>

<p>
Book vendors as hyperlinks:
</p>

<%-- _DISPLAY_HYPERLINK_URL_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT name, website FROM book_vendor ORDER BY name
</sql:query>

<ul>
<c:forEach items="${rs.rows}" var="row">
  <li>
    <a href="http://<c:out value="${row.website}"/>">
      <c:out value="${row.name}"/></a>
  </li>
</c:forEach>
</ul>
<%-- _DISPLAY_HYPERLINK_URL_ --%>

<p>
News staff email directory:
</p>

<%-- _NEWSSTAFF_DIRECTORY_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT department, name, email
  FROM newsstaff
  ORDER BY department, name
</sql:query>

<ul>
<c:forEach items="${rs.rows}" var="row">
  <li>
    <c:out value="${row.department}"/>:
    <c:set var="name" value="${row.name}"/>
    <c:set var="email" value="${row.email}"/>
    <c:choose>
      <%-- null or empty value test --%>
      <c:when test="${empty email}">
        <c:out value="${name}"/>
      </c:when>
      <c:otherwise>
        <a href="mailto:<c:out value="${email}"/>">
          <c:out value="${name}"/></a>
      </c:otherwise>
    </c:choose>
  </li>
</c:forEach>
</ul>
<%-- _NEWSSTAFF_DIRECTORY_ --%>

</body>
</html>
