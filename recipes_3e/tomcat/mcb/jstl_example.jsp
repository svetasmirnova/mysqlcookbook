<%-- jstl_example.jsp: sample page to demonstrate use of JSTL --%>

<%-- #@ _TAGLIB_DIRECTIVES_ --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%-- #@ _TAGLIB_DIRECTIVES_ --%>
<%-- #@ _INCLUDE_FILE_ --%>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>
<%-- #@ _INCLUDE_FILE_ --%>

<%-- #@ _SET_TITLE_ --%>
<c:set var="title" value="JSTL Example Page"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<%-- #@ _SET_TITLE_ --%>
<body>

<p>1 + 2 =
<%-- #@ _OUT_EXPR_ --%>
<c:out value="${1+2}"/>
<%-- #@ _OUT_EXPR_ --%>
</p>

<p>
<%-- #@ _IF_EXPR_ --%>
<c:if test="${1 != 0}">
1 is not equal to 0
</c:if>
<%-- #@ _IF_EXPR_ --%>
</p>

<p>
<%-- #@ _IF_EMPTY_ --%>
<c:set var="x" value=""/>
<c:if test="${empty x}">
x is empty
</c:if>
<c:set var="y" value="hello"/>
<c:if test="${!empty y}">
y is not empty
</c:if>
<%-- #@ _IF_EMPTY_ --%>
</p>

<p>choose test:</p>
<c:forEach items="0,1,2" var="count">
<p>
count = <c:out value="${count}"/>, choose result =
<%-- #@ _CHOOSE_EXPR_ --%>
<c:choose>
  <c:when test="${count == 0}">
    Please choose an item
  </c:when>
  <c:when test="${count gt 1}">
    Please choose only one item
  </c:when>
  <c:otherwise>
    Thank you for choosing exactly one item
  </c:otherwise>
</c:choose>
<%-- #@ _CHOOSE_EXPR_ --%>
</p>
</c:forEach>

<p>Query: DELETE FROM profile WHERE id &gt; 100</p>

<%-- #@ _UPDATE_ --%>
<sql:update dataSource="${conn}" var="count">
  DELETE FROM profile WHERE id > 100
</sql:update>
Number of rows deleted: <c:out value="${count}"/>
<%-- #@ _UPDATE_ --%>
<br>

<p>Query: SELECT id, name FROM profile ORDER BY id</p>


<%-- #@ _SELECT_1_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT id, name FROM profile ORDER BY id
</sql:query>
<%-- #@ _SELECT_1_ --%>
<%-- #@ _ROWCOUNT_ --%>
Number of rows selected: <c:out value="${rs.rowCount}"/>
<%-- #@ _ROWCOUNT_ --%>
<br />
Column names:
<br />
<%-- #@ _COLUMN_NAMES_ --%>
<c:forEach items="${rs.columnNames}" var="name">
  <c:out value="${name}"/>
  <br />
</c:forEach>
<%-- #@ _COLUMN_NAMES_ --%>
Rows:
<br />
<%-- #@ _FOREACH_ --%>
<c:forEach items="${rs.rows}" var="row">
  id = <c:out value="${row.id}"/>,
  name = <c:out value="${row.name}"/>
  <br />
</c:forEach>
<%-- #@ _FOREACH_ --%>

<%-- placeholder value in <sql:param> body --%>
<%-- #@ _PLACEHOLDER_1_ --%>
<sql:update dataSource="${conn}" var="count">
  DELETE FROM profile WHERE id > ?
  <sql:param>100</sql:param>
</sql:update>
<%-- #@ _PLACEHOLDER_1_ --%>
<%-- placeholder value in <sql:param> value attribute --%>
<%-- #@ _PLACEHOLDER_2_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT id, name FROM profile WHERE cats = ? AND color = ?
  <sql:param value="1"/>
  <sql:param value="green"/>
</sql:query>
<%-- #@ _PLACEHOLDER_2_ --%>

<%-- #@ _SELECT_2_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT id, name FROM profile ORDER BY id
</sql:query>
<%-- #@ _SELECT_2_ --%>
Row 3, columns by name:
<%-- #@ _ROW_3_BY_NAME_ --%>
<c:out value="${rs.rows[2].id}"/>
<c:out value="${rs.rows[2].name}"/>
<%-- #@ _ROW_3_BY_NAME_ --%>
<br />
Row 3, columns by number:
<%-- #@ _ROW_3_BY_NUMBER_ --%>
<c:out value="${rs.rowsByIndex[2][0]}"/>
<c:out value="${rs.rowsByIndex[2][1]}"/>
<%-- #@ _ROW_3_BY_NUMBER_ --%>
<br />

Iterate through rows, columns by name:<br />
<%-- #@ _ITERATE_ROWS_ --%>
<c:forEach items="${rs.rows}" var="row">
  id = <c:out value="${row.id}"/>,
  name = <c:out value="${row.name}"/>
  <br />
</c:forEach>
<%-- #@ _ITERATE_ROWS_ --%>

Iterate through rows, columns by number:<br />
<%-- #@ _ITERATE_ROWSBYINDEX_ --%>
<c:forEach items="${rs.rowsByIndex}" var="row">
  id = <c:out value="${row[0]}"/>,
  name = <c:out value="${row[1]}"/>
  <br />
</c:forEach>
<%-- #@ _ITERATE_ROWSBYINDEX_ --%>

</body>
</html>
