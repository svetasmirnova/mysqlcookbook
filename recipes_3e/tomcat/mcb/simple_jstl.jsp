<%--
  simple_jstl.jsp: simple page that uses the JSTL tags
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Simple JSTL Page"/>
<c:set var="content" value="Hello."/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>
<c:out value="${content}"/></title>
</body>
</html>
