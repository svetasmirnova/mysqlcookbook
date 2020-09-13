<%-- lists.jsp: generate HTML lists --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Query Output Display - Lists"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<%-- generate result set for ordered and unordered lists --%>

<%-- #@ _ITEM_QUERY_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT item FROM ingredient ORDER BY id
</sql:query>
<%-- #@ _ITEM_QUERY_ --%>

<p>Ordered list:</p>

<%-- #@ _DISPLAY_ORDERED_LIST_ --%>
<ol>
<c:forEach items="${rs.rows}" var="row">
  <li><c:out value="${row.item}"/></li>
</c:forEach>
</ol>
<%-- #@ _DISPLAY_ORDERED_LIST_ --%>

<p>Unordered list:</p>

<%-- #@ _DISPLAY_UNORDERED_LIST_ --%>
<ul>
<c:forEach items="${rs.rows}" var="row">
  <li><c:out value="${row.item}"/></li>
</c:forEach>
</ul>
<%-- #@ _DISPLAY_UNORDERED_LIST_ --%>

<p>Unmarked list:</p>

<%-- #@ _DISPLAY_UNMARKED_LIST_ --%>
<c:forEach items="${rs.rows}" var="row">
  <c:out value="${row.item}"/><br />
</c:forEach>
<%-- #@ _DISPLAY_UNMARKED_LIST_ --%>

<%-- generate result set for definition list --%>

<p>Definition list:</p>

<%-- #@ _DEFINITION_QUERY_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT note, mnemonic FROM doremi ORDER BY note
</sql:query>
<%-- #@ _DEFINITION_QUERY_ --%>

<%-- #@ _DISPLAY_DEFINITION_LIST_ --%>
<dl>
<c:forEach items="${rs.rows}" var="row">
  <dt><c:out value="${row.note}"/></dt>
  <dd><c:out value="${row.mnemonic}"/></dd>
</c:forEach>
</dl>
<%-- #@ _DISPLAY_DEFINITION_LIST_ --%>

</body>
</html>
