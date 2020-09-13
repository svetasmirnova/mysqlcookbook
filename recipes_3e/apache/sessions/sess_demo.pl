#!/usr/bin/perl
# sess_demo.pl: Apache::Session usage overview that demonstrates some
# session-handling concepts

# This is a command-line script. It doesn't require (or work with) Apache.

use strict;
use warnings;
#@ _USE_STATEMENT_1_
use Apache::Session::MySQL;
#@ _USE_STATEMENT_1_

# session hash; this is used globally

#@ _SESSION_VAR_
my %session;
#@ _SESSION_VAR_

my $sess_id = undef;

session_with_params ($sess_id);

#@ _NEW_SESSION_ID_
$sess_id = $session{_session_id};
#@ _NEW_SESSION_ID_

my $count;
#@ _COUNTER_VALUE_
$session{count} = 0 if !exists ($session{count}); # initialize counter
++$session{count};                                # increment counter
print "counter value: $session{count}\n";         # print value
#@ _COUNTER_VALUE_

# try that all again just to make sure it increments
$session{count} = 0 if !exists ($session{count}); # initialize counter
++$session{count};                                # increment counter
print "counter value: $session{count}\n";         # print value

foreach my $key (keys (%session))
{
  print "$key: $session{$key}\n";
}

my @my_array = ("a", "b", "c");
my %my_hash = ("a" => 1, "b" => 2, "c" => 3);

print "@my_array\n";
print join (", ", map { "$_ => $my_hash{$_}" } sort (keys (%my_hash))), "\n";

# save references to the actual structures; changes
# to the structures will be reflected in the session
#@ _SAVE_NONSCALAR_REF_
$session{my_array} = \@my_array;
$session{my_hash} = \%my_hash;
#@ _SAVE_NONSCALAR_REF_
# save references to copies of the structures; changes
# to the structures will not be reflected in the session
#@ _SAVE_NONSCALAR_COPY_
$session{my_array} = [ @my_array ];
$session{my_hash} = { %my_hash };
#@ _SAVE_NONSCALAR_COPY_
#@ _RETRIEVE_NONSCALAR_
@my_array = @{$session{my_array}};
%my_hash = %{$session{my_hash}};
#@ _RETRIEVE_NONSCALAR_
print "@my_array\n";
print join (", ", map { "$_ => $my_hash{$_}" } sort (keys (%my_hash))), "\n";

# save the session

#@ _UNTIE_SESSION_
untie (%session);
#@ _UNTIE_SESSION_

# re-open session, then clobber it

session_with_params ($sess_id);

#@ _DELETE_SESSION_
tied (%session)->delete ();
#@ _DELETE_SESSION_

# Same as above, but use an existing database handle to open sessions.

#@ _USE_STATEMENT_2_
use Cookbook;
#@ _USE_STATEMENT_2_

my $dbh = Cookbook::connect ();
$sess_id = undef;
session_with_dbh ($dbh, $sess_id);
$sess_id = $session{_session_id};
untie (%session);
session_with_dbh ($dbh, $sess_id);
tied (%session)->delete ();
$dbh->disconnect ();

# Set up a session by specifying the connection parameters explicitly:

sub session_with_params
{
my $sess_id = shift;
#@ _SESSION_WITH_EXPLICIT_PARAMS_
tie %session,
    "Apache::Session::MySQL",
    $sess_id,
    {
      DataSource     => "DBI:mysql:host=localhost;database=cookbook",
      UserName       => "cbuser",
      Password       => "cbpass",
      LockDataSource => "DBI:mysql:host=localhost;database=cookbook",
      LockUserName   => "cbuser",
      LockPassword   => "cbpass",
      TableName      => "perl_session"
    };
#@ _SESSION_WITH_EXPLICIT_PARAMS_
}

# Set up a session by specifying a database handle

sub session_with_dbh
{
my ($dbh, $sess_id) = @_;
#@ _SESSION_WITH_HANDLE_
tie %session,
    "Apache::Session::MySQL",
    $sess_id,
    {
      Handle     => $dbh,
      LockHandle => $dbh,
      TableName  => "perl_session"
    };
#@ _SESSION_WITH_HANDLE_
}
