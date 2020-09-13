By default, Tomcat uses the tomcat-users.xml file in its conf directory
to define Tomcat users, passwords, and roles.  For example, the file
distributed with Tomcat might look like this:

<!--
  NOTE:  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary.
-->
<!--
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="tomcat" password="tomcat" roles="tomcat"/>
  <user username="both" password="tomcat" roles="tomcat,role1"/>
  <user username="role1" password="tomcat" roles="role1"/>
-->

To tell Tomcat to use MySQL for user information instead, use this procedure:

- Create the tables required to store user records.  You must have a
  table for users and a table for roles.

  CREATE TABLE tomcat_user
  (
    user_name VARCHAR(30) NOT NULL,
    user_pass VARCHAR(30) NOT NULL,
    PRIMARY KEY (user_name)
  );

  CREATE TABLE tomcat_role
  (
    user_name VARCHAR(30) NOT NULL,
    role_name VARCHAR(30) NOT NULL,
    PRIMARY KEY (user_name, role_name)
  );

- Create the users and roles that you want to set up.  The following
  statements add a user with the "manager-gui" role, which permits the user
  access to the Tomcat Manager application.
  (Note: you probably want to change these values so that other people
  can't connect to your Tomcat server and user the Manager app!)

  INSERT INTO tomcat_user (user_name, user_pass)
    VALUES ('mgr_user', 'mgr_pass');
  INSERT INTO tomcat_role (user_name, role_name)
    VALUES ('mgr_user', 'manager-gui');

- Configure Tomcat's server.xml file to add a <Realm> element that specifies
  the use of persistent storage for user records.  For example, look for
  and <Engine> element that begins like this:

  <!-- Define the top level container in our container hierarchy -->
  <Engine name="Standalone" defaultHost="localhost" debug="0">

  Within that element, add the following <Realm> element:

  <Realm
    className="org.apache.catalina.realm.JDBCRealm"
    debug="0"
    driverName="com.mysql.jdbc.Driver"
    connectionURL="jdbc:mysql://localhost/cookbook"
    connectionName="cbuser"
    connectionPassword="cbpass"
    userTable="tomcat_user"
    userNameCol="user_name"
    userCredCol="user_pass"
    userRoleTable="tomcat_role"
    roleNameCol="role_name"
  />

- Restart Tomcat, then request the Manager application from your browser:

  http://localhost:8080/manager/html/list

  When the browser prompts for a name and password, use "mgr_user"
  and "mgr_pass" (as specified in the INSERT statement above).
