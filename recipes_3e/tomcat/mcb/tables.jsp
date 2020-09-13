<%-- tables.jsp: generate HTML tables --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Query Output Display - Tables"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<p>
Display HTML table.
</p>

<%-- _DISPLAY_CD_TABLE_ --%>
<table border="1">
  <tr>
    <th>Year</th>
    <th>Artist</th>
    <th>Title</th>
  </tr>
<sql:query dataSource="${conn}" var="rs">
  SELECT year, artist, title FROM cd ORDER BY artist, year
</sql:query>
<c:forEach items="${rs.rows}" var="row">
  <tr>
    <td><c:out value="${row.year}"/></td>
    <td><c:out value="${row.artist}"/></td>
    <td><c:out value="${row.title}"/></td>
  </tr>
</c:forEach>

</table>
<%-- _DISPLAY_CD_TABLE_ --%>

<p>
Display HTML table with alternating color for rows.
</p>

<c:set var="color" value="silver"/>
<c:set var="style" value="background-color:${color}"/>
<table border="1">
  <tr>
    <th style="<c:out value="${style}"/>">Year</th>
    <th style="<c:out value="${style}"/>">Artist</th>
    <th style="<c:out value="${style}"/>">Title</th>
  </tr>
<sql:query dataSource="${conn}" var="rs">
  SELECT year, artist, title FROM cd ORDER BY artist, year
</sql:query>
<c:forEach items="${rs.rows}" var="row">
  <c:choose>
    <c:when test="${color eq 'silver'}">
      <c:set var="color" value="white"/>
    </c:when>
    <c:otherwise>
      <c:set var="color" value="silver"/>
    </c:otherwise>
  </c:choose>
  <c:set var="style" value="background-color:${color}"/>
  <tr>
    <td style="<c:out value="${style}"/>">
      <c:out value="${row.year}"/>
    </td>
    <td style="<c:out value="${style}"/>">
      <c:out value="${row.artist}"/>
    </td>
    <td style="<c:out value="${style}"/>">
      <c:out value="${row.title}"/>
    </td>
  </tr>
</c:forEach>

</table>

<p>
Display HTML table.
</p>

<table border="1">
  <tr>
    <th>State</th>
    <th>Statehood</th>
    <th>Population</th>
  </tr>

<sql:query dataSource="${conn}" var="rs">
  SELECT name, statehood, pop FROM states ORDER BY name
</sql:query>
<c:forEach items="${rs.rows}" var="row">
  <tr>
    <td><c:out value="${row.name}"/></td>
    <td><c:out value="${row.statehood}"/></td>
    <td align="right"><c:out value="${row.pop}"/></td>
  </tr>
</c:forEach>

</table>

</body>
</html>
