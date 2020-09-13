httpdlog.pl logs to the httpdlog table, which does not include a vhost
column for virtual host information.

httpdlog2.pl logs to the httpdlog2 table, which does include a vhost
column for virtual host information.

See logdirectives.txt for the appropriate httpd.conf lines to set
up the logging format for each script.
