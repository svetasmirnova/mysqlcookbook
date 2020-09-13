To tell Tomcat to store session information in MySQL, use the following
procedure:

- Create the tomcat_session table using the script in the
  tables/tomcat_session.sql file.

- Change location to the mcb/META-INF directory (this assumes that the mcb
  application is already unpacked under the Tomcat webapps directory).

- Copy context.xml.jdbc to context.xml.

- Restart Tomcat.

To tell Tomcat to stop storing session information in MySQL, remove that
context.xml file and restart Tomcat.
