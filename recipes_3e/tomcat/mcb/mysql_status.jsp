<%-- mysql_status.jsp: print some MySQL server status information --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<html>
<head><title>MySQL Server Status</title></head>
<body>

<sql:query dataSource="${conn}" var="rs">
  SELECT NOW(), VERSION()
</sql:query>
<c:set var="now" value="${rs.rowsByIndex[0][0]}"/>
<c:set var="version" value="${rs.rowsByIndex[0][1]}"/>
<%-- SHOW STATUS variables are in the second result column --%>
<sql:query dataSource="${conn}" var="rs">
  SHOW GLOBAL STATUS LIKE 'Questions'
</sql:query>
<c:set var="queries" value="${rs.rowsByIndex[0][1]}"/>
<sql:query dataSource="${conn}" var="rs">
  SHOW GLOBAL STATUS LIKE 'Uptime'
</sql:query>
<c:set var="uptime" value="${rs.rowsByIndex[0][1]}"/>
<c:set var="qPerSec" value="${queries/uptime}"/>

<p>Current time: <c:out value="${now}"/></p>
<p>Server version: <c:out value="${version}"/></p>
<p>Server uptime (seconds): <c:out value="${uptime}"/></p>
<p>Queries processed: <c:out value="${queries}"/>
(<c:out value="${qPerSec}"/> queries/second)</p>

</body>
</html>
