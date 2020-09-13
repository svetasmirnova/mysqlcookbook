<%--
  phrase.jsp: demonstrate HTML-encoding and URL-encoding using
  values in phrase table.
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<c:set var="title" value="Links generated from phrase table"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<p>Links generated from phrase table</p>

<%-- #@ _MAIN_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT phrase_val FROM phrase ORDER BY phrase_val
</sql:query>

<c:forEach items="${rs.rows}" var="row">
  <%-- URL-encode the phrase value for use in the URL --%>
  <c:url var="urlStr" value="/mcb/mysearch.jsp">
    <c:param name="phrase" value ="${row.phrase_val}"/>
  </c:url>
  <a href="<c:out value="${urlStr}"/>">
    <%-- HTML-encode the phrase value for use in the link label --%>
    <c:out value="${row.phrase_val}"/>
  </a>
  <br />
</c:forEach>
<%-- #@ _MAIN_ --%>

</body>
</html>
