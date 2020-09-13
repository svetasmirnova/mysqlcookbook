#!/bin/sh

(cd mcb/WEB-INF/classes && javac SimpleServlet.java) || exit 1
(cd mcb/WEB-INF/classes && javac GetOrPostServlet.java) || exit 1
rm -f ./mcb.war
cd mcb
# RedHat 7.0 jar is busted and generates bad WAR file with mcb/ in
# pathnames.
#jar cf ../mcb.war .
zip -r ../mcb.war .
