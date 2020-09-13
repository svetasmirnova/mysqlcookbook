# create_user.sql

# create_user() creates a MySQL account, taking care of the details of
# setting old_passwords appropriately for the specified authentication
# plugin.
# If the ALTER USER statement is available (MySQL 5.6.7) and user is not
# anonymous, expire password immediately

# Requires the exec_stmt() procedure and server_version() function.

DROP PROCEDURE IF EXISTS create_user;
delimiter $$
#@ _DEFINITION_
CREATE PROCEDURE create_user(user TEXT, host TEXT,
                             password TEXT, plugin TEXT)
BEGIN
  DECLARE account TEXT;
  SET account = CONCAT(QUOTE(user),'@',QUOTE(host));
  CALL exec_stmt(CONCAT('CREATE USER ',account,
                        ' IDENTIFIED WITH ',QUOTE(plugin)));
  IF password IS NOT NULL THEN
    BEGIN
      DECLARE saved_old_passwords INT;
      SET saved_old_passwords = @@old_passwords;
      CASE plugin
        WHEN 'mysql_native_password' THEN SET old_passwords = 0;
        WHEN 'mysql_old_password' THEN SET old_passwords = 1;
        WHEN 'sha256_password' THEN SET old_passwords = 2;
        ELSE SIGNAL SQLSTATE 'HY000'
                    SET MYSQL_ERRNO = 1525,
                        MESSAGE_TEXT = 'unhandled auth plugin';
      END CASE;
      CALL exec_stmt(CONCAT('SET PASSWORD FOR ',account,
                            ' = PASSWORD(',QUOTE(PASSWORD),')'));
      SET old_passwords = saved_old_passwords;
    END;
  END IF;
  IF server_version() >= 50607 AND user <> '' THEN
    CALL exec_stmt(CONCAT('ALTER USER ',account,' PASSWORD EXPIRE'));
  END IF;
END;
#@ _DEFINITION_
$$
delimiter ;

-- Use a password that should satisfy most password-strength policies
SET @password='Str0ng-Pa33w0rd';

DROP USER 'user1'@'localhost';
CALL create_user('user1','localhost',@password,'mysql_native_password');
SHOW GRANTS FOR 'user1'@'localhost';
DROP USER 'user2'@'localhost';
CALL create_user('user2','localhost',@password,'mysql_old_password');
SHOW GRANTS FOR 'user2'@'localhost';
DROP USER 'user3'@'localhost';
CALL create_user('user3','localhost',NULL,'sha256_password');
SHOW GRANTS FOR 'user3'@'localhost';
SELECT 'Next create_user() call should fail' AS Message;
CALL create_user('user4','localhost','mypass','bad plugin name');
