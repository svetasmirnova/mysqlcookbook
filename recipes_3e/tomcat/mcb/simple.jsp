<html>
<head><title>Simple JSP Page</title></head>
<body>
<p>Hello.</p>
<p>Current date: <%= new java.util.Date () %></p>
<p>Your IP address: <%= request.getRemoteAddr () %></p>
</body>
</html>
