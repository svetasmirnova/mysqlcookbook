<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="HTML/URL-encoding test"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<p>HTML-encoding test:</p>

Attribute-encoding test: <c:out value="<>&;"/><br />

<p>URL-encoding test:</p>

Attribute-encoding test: <c:url var="urlStr" value="<>&;:/?" />
<c:out value="${urlStr}"/></br />

</body>
</html>
