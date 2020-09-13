<%--
  sess_track.jsp: session request counting/timestamping demonstration
--%>

<%@ page import="java.util.*" %>
<%
  // get session variables, initializing them if not present

  int count;
  Object obj = session.getAttribute ("count");
  if (obj == null)
    count = 0;
  else
    count = Integer.parseInt (obj.toString ());

  ArrayList timestamp = (ArrayList) session.getAttribute ("timestamp");
  if (timestamp == null)
    timestamp = new ArrayList ();

  // increment counter, add current timestamp to timestamp array

  count = count + 1;
  timestamp.add (new Date ());

  if (count < 10)   // save updated values in session object
  {
    session.setAttribute ("count", String.valueOf (count));
    session.setAttribute ("timestamp", timestamp);
  }
  else              // restart session after 10 requests
  {
    session.invalidate ();
  }
%>

<html>
<head><title>JSP Session Tracker</title></head>
<body>

<p>This session has been active for <%= count %> requests.</p>
<p>The requests occurred at these times:</p>
<ol>
<%
  for (int i = 0; i < timestamp.size (); i++)
    out.println ("<li>" + timestamp.get (i) + "</li>");
%>
</ol>
<p>Reload page to send next request.</p>

</body>
</html>
