# expire_password.sql

# expire_password() takes an account given as a user name and host name and
# expires its password if the ALTER USER statement is available (MySQL 5.6.7)
# and user is not anonymous. This is a simple example of adaptive SQL.

# Requires the exec_stmt() procedure and server_version() function.

DROP PROCEDURE IF EXISTS expire_password;
delimiter $$
#@ _DEFINITION_
CREATE PROCEDURE expire_password(user TEXT, host TEXT)
BEGIN
  DECLARE account TEXT;
  SET account = CONCAT(QUOTE(user),'@',QUOTE(host));
  IF server_version() >= 50607 AND user <> '' THEN
    CALL exec_stmt(CONCAT('ALTER USER ',account,' PASSWORD EXPIRE'));
  END IF;
END;
#@ _DEFINITION_
$$
delimiter ;

CALL expire_password('user7','localhost');
