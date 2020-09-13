<%-- cow_edit.jsp: Present form for editing record in cow_order table. --%>
<%-- (Display only; does not actually process submitted contents.) --%>

<%-- Form has fields that are initialized to the column values from a --%>
<%-- record in the table.  (The script uses record 1.) --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ include file="/WEB-INF/jstl-mcb-setup.inc" %>

<%-- _GET_ENUM_OR_SET_VALUES_ --%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>

<%!
// declare a class method for breaking apart ENUM/SET values.
// typeDefAttr - the name of the page context attribute that contains
// the columm type definition
// valListAttr - the name of the page context attribute in which to
// store the column value list

void getEnumOrSetValues (PageContext ctx,
                         String typeDefAttr,
                         String valListAttr)
{
  String typeDef = ctx.getAttribute (typeDefAttr).toString ();
  List values = new ArrayList ();

  // column must be an ENUM or SET
  Pattern pc = Pattern.compile ("(enum|set)\\((.*)\\)",
                                Pattern.CASE_INSENSITIVE);
  Matcher m = pc.matcher (typeDef);
  // matches() fails unless it matches entire string
  if (m.matches ())
  {
    // split value list on commas, trim quotes from end of each word
    String[] v = m.group (2).split (",");
    for (int i = 0; i < v.length; i++)
      values.add (v[i].substring (1, v[i].length() - 1));
  }
  ctx.setAttribute (valListAttr, values);
}

%>
<%-- _GET_ENUM_OR_SET_VALUES_ --%>

<c:set var="title" value="Cow Figuring Order Record Editing Form"/>

<html>
<head><title><c:out value="${title}"/></title></head>
<body>

<form action="<%= request.getRequestURI () %>" method="post">

<%-- Retrieve a record by ID from the cow_order table --%>

<%-- #@ _FETCH_ORDER_INFO_ --%>
<c:set var="id" value="1"/>
<sql:query dataSource="${conn}" var="rs">
  SELECT
    id, color, size, accessories,
    cust_name, cust_street, cust_city, cust_state
  FROM cow_order WHERE id = ?
  <sql:param value="${id}"/>
</sql:query>

<c:set var="row" value="${rs.rows[0]}"/>
<c:set var="id" value="${row.id}"/>
<c:set var="color" value="${row.color}"/>
<c:set var="size" value="${row.size}"/>
<c:set var="accessories" value="${row.accessories}"/>
<c:set var="cust_name" value="${row.cust_name}"/>
<c:set var="cust_street" value="${row.cust_street}"/>
<c:set var="cust_city" value="${row.cust_city}"/>
<c:set var="cust_state" value="${row.cust_state}"/>
<%-- #@ _FETCH_ORDER_INFO_ --%>

<p>Values to be loaded into form:</p>
<ul>
<li>id = <c:out value="${id}"/>
(this is a hidden field; use 'show source' to see it)</li>
<li>color = <c:out value="${color}"/></li>
<li>size = <c:out value="${size}"/></li>
<li>accessories = <c:out value="${accessories}"/></li>
<li>cust_name = <c:out value="${cust_name}"/></li>
<li>cust_street = <c:out value="${cust_street}"/></li>
<li>cust_city = <c:out value="${cust_city}"/></li>
<li>cust_state = <c:out value="${cust_state}"/></li>
</ul>

<%--
Generate various types of form elements, using the cow_order record
to provide the default value for each element.
--%>

<%-- Put ID value into a hidden field --%>

<%-- #@ _PRINT_ID_HIDDEN_ --%>
<input type="hidden" name="id" value="<c:out value="${id}"/>"/>
<%-- #@ _PRINT_ID_HIDDEN_ --%>

<%-- Retrieve values for color list --%>

<%-- #@ _FETCH_COLOR_LIST_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT color FROM cow_color ORDER BY color
</sql:query>
<%-- #@ _FETCH_COLOR_LIST_ --%>

<%-- #@ _PRINT_COLOR_POPUP_ --%>
<br />Cow color:<br />
<select name="color">
<c:forEach items="${rs.rows}" var="row">
  <option
    value="<c:out value="${row.color}"/>"
    <c:if test="${row.color == color}">selected="selected"</c:if>
  ><c:out value="${row.color}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_COLOR_POPUP_ --%>

<%-- #@ _FETCH_SIZE_INFO_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT COLUMN_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'cookbook' AND TABLE_NAME = 'cow_order'
  AND COLUMN_NAME = 'size'
</sql:query>
<c:set var="typeDef" scope="page" value="${rs.rowsByIndex[0][0]}"/>
<% getEnumOrSetValues (pageContext, "typeDef", "values"); %>
<%-- #@ _FETCH_SIZE_INFO_ --%>

<%-- #@ _PRINT_SIZE_RADIO_ --%>
<br />Cow figurine size:<br />
<c:forEach items="${values}" var="val">
  <input type="radio" name="size"
    value="<c:out value="${val}"/>"
    <c:if test="${val == size}">checked="checked"</c:if>
  /><c:out value="${val}"/><br />
</c:forEach>
<%-- #@ _PRINT_SIZE_RADIO_ --%>

<%-- #@ _FETCH_ACCESSORY_INFO_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT COLUMN_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'cookbook'
  AND TABLE_NAME = 'cow_order'
  AND COLUMN_NAME = 'accessories'
</sql:query>
<c:set var="typeDef" scope="page" value="${rs.rowsByIndex[0][0]}"/>
<% getEnumOrSetValues (pageContext, "typeDef", "values"); %>
<%-- #@ _FETCH_ACCESSORY_INFO_ --%>

<%-- #@ _PRINT_ACCESSORY_CHECKBOX_ --%>
<br />Cow accessory items:<br />
<c:forEach items="${values}" var="val">
  <input type="checkbox" name="accessories"
    value="<c:out value="${val}"/>"
    <c:forEach items="${accessories}" var="default">
      <c:if test="${val == default}">checked="checked"</c:if>
    </c:forEach>
  /><c:out value="${val}"/><br />
</c:forEach>
<%-- #@ _PRINT_ACCESSORY_CHECKBOX_ --%>

<%-- #@ _PRINT_CUST_NAME_TEXT_ --%>
<br />Customer name:<br />
<input type="text" name="cust_name"
  value="<c:out value="${cust_name}"/>"
  size="60" />
<%-- #@ _PRINT_CUST_NAME_TEXT_ --%>

<%-- #@ _PRINT_CUST_STREET_TEXT_ --%>
<br />Customer street address:<br />
<input type="text" name="cust_street"
  value="<c:out value="${cust_street}"/>"
  size="60" />
<%-- #@ _PRINT_CUST_STREET_TEXT_ --%>

<%-- #@ _PRINT_CUST_CITY_TEXT_ --%>
<br />Customer city:<br />
<input type="text" name="cust_city"
  value="<c:out value="${cust_city}"/>"
  size="60" />
<%-- #@ _PRINT_CUST_CITY_TEXT_ --%>

<%-- #@ _FETCH_STATE_LIST_ --%>
<sql:query dataSource="${conn}" var="rs">
  SELECT abbrev, name FROM states ORDER BY name
</sql:query>
<%-- #@ _FETCH_STATE_LIST_ --%>

<%-- #@ _PRINT_STATE_SCROLLING_SINGLE_ --%>
<br />Customer state:<br />
<select name="state" size="6">
<c:forEach items="${rs.rows}" var="row">
  <option value="<c:out value="${row.abbrev}"/>"
    <c:if test="${row.abbrev == cust_state}">selected="selected"</c:if>
  ><c:out value="${row.name}"/></option>
</c:forEach>
</select>
<%-- #@ _PRINT_STATE_SCROLLING_SINGLE_ --%>

</form>

</body>
</html>
