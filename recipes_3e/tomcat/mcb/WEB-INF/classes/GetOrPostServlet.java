// Servlet that illustrates a rudimentary doPost() method that does
// nothing but invoke doGet().  This enables the servlet to handle
// both GET and PUT requests.

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

// #@ _FRAG1_
public class GetOrPostServlet extends HttpServlet
{
  public void doGet (HttpServletRequest request,
                     HttpServletResponse response)
    throws IOException, ServletException
  {
// #@ _FRAG1_
    PrintWriter out = response.getWriter ();

    response.setContentType ("text/html");
    out.println ("<html>");
    out.println ("<head><title>Get-or-Post Servlet</title></head>");
    out.println ("<body>");
    out.println ("<p>Request method: " + request.getMethod () + "</p>");
    out.println ("</body>");
    out.println ("</html>");
// #@ _FRAG2_
  }

  public void doPost (HttpServletRequest request,
                      HttpServletResponse response)
    throws IOException, ServletException
  {
    doGet (request, response);
  }
}
// #@ _FRAG2_
