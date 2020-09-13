<%--
  BUG: color is used as multiple-pick items; should be single-pick.
  Add m-p item like accessories
--%>
<%-- show_params.jsp: print request parameter names and values --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="title" value="Script Input Parameters"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<c:set var="selfPath">
  <%= request.getRequestURI () %>
</c:set>

<ul>
<li>Request URI: <c:out value="${selfPath}"/></li>
</ul>

<p>Request parameters (using implicit request object):</p>
<%-- #@ _DISPLAY_PARAMS_REQUEST_OBJECT_ --%>
<%@ page import="java.util.*" %>

<ul>
<%
  Enumeration e = request.getParameterNames ();
  while (e.hasMoreElements ())
  {
    String name = (String) e.nextElement ();
    // use array in case parameter is multiple-valued
    String[] val = request.getParameterValues (name);
    out.println ("<li> name: " + name + "; values:");
    for (int i = 0; i < val.length; i++)
      out.println (val[i]);
    out.println ("</li>");
  }
%>
</ul>
<%-- #@ _DISPLAY_PARAMS_REQUEST_OBJECT_ --%>

<p>Request parameters (using JSTL tags):</p>
<%-- #@ _DISPLAY_PARAMS_JSTL_ --%>
<ul>
  <c:forEach items="${paramValues}" var="p">
    <li>
      name:
      <c:out value="${p.key}"/>;
      values:
      <c:forEach items="${p.value}" var="val">
        <c:out value="${val}"/>
      </c:forEach>
    </li>
  </c:forEach>
</ul>
<%-- #@ _DISPLAY_PARAMS_JSTL_ --%>

<%-- access individual parameter, first value or as array of values --%>

<%-- #@ _SINGLE_VALUED_PARAM_JSTL_ --%>
color value:
<c:out value="${param['color']}"/>
<%-- #@ _SINGLE_VALUED_PARAM_JSTL_ --%>
<br />
<%-- #@ _MULTIPLE_VALUED_PARAM_JSTL_ --%>
accessory values:
<c:forEach items="${paramValues['accessories']}" var="val">
  <c:out value="${val}"/>
</c:forEach>
<%-- #@ _MULTIPLE_VALUED_PARAM_JSTL_ --%>

<br />
<%-- #@ _DOT_NOTATION_PARAM_JSTL_1_ --%>
color value:
<c:out value="${param.color}"/>
<%-- #@ _DOT_NOTATION_PARAM_JSTL_1_ --%>
<br />
<%-- #@ _DOT_NOTATION_PARAM_JSTL_2_ --%>
accessory values:
<c:forEach items="${paramValues.accessories}" var="val">
  <c:out value="${val}"/>
</c:forEach>
<%-- #@ _DOT_NOTATION_PARAM_JSTL_2_ --%>

<p>Form 1:</p>

<form action="<c:out value="${selfPath}"/>" method="get">
Enter a text value:
<input type="text" name="text_field" size="60"><br />
Select any combination of colors:<br />
<input type="checkbox" name="color" value="red" />red
<input type="checkbox" name="color" value="white" />white
<input type="checkbox" name="color" value="blue" />blue
<input type="checkbox" name="color" value="black" />black
<input type="checkbox" name="color" value="silver" />silver
<br />
<input type="submit" name="choice" value="Submit by get">
</form>

<p>Form 2:</p>

<form action="<c:out value="${selfPath}"/>" method="post">
Enter a text value:
<input type="text" name="text_field" size="60"><br />
Select any combination of colors:<br />
<input type="checkbox" name="color" value="red" />red
<input type="checkbox" name="color" value="white" />white
<input type="checkbox" name="color" value="blue" />blue
<input type="checkbox" name="color" value="black" />black
<input type="checkbox" name="color" value="silver" />silver
<br />
<input type="submit" name="choice" value="Submit by post">
</form>

</body>
</html>
