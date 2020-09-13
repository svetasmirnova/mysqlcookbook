MySQL Cookbook (third edition) recipes Distribution
Paul DuBois, paul@kitebird.com

This is the recipes distribution that accompanies MySQL Cookbook,
third edition (O'Reilly Media, (c) 2014).  The latest version of
the distribution and the errata list for the book are available at:

  http://www.kitebird.com/mysql-cookbook/

See also the Changes.txt file.

If you find that files appear to be missing from this distribution,
please let me know.

If you are using a database name other than "cookbook", substitute that
name wherever you see cookbook in the distribution files.

If you were using scripts from the second edition of MySQL Cookbook
and now have "upgraded" to the third edition of the book, there are
some important notes you should read at the end of this file.

Directories in this distribution:

tables
  SQL scripts for creating tables used in the book
mysql
  Using the mysql client program (chapter 1)
api
  MySQL programming; API basics (chapter 2)
lib
  Library files use by lots of programs (chapter 2, other later chapters)
select
  Record selection techniques (chapter 3)
tblmgmt
  Table management scripts (chapter 4)
strings
  Using strings (chapter 5)
dates
  Date and time manipulation (chapter 6)
sorting
  Sorting operations (chapter 7)
summary
  Summary operations (chapter 8)
routines, triggers, events
  Stored program (chapter 9)
metadata
  Using metadata (chapter 10)
transfer
  Data import/export, validation (chapters 11, 12)
sequences
  Using sequences (chapter 13)
joins
  Multi-table joins (chapter 14)
stats
  Statistical techniques (chapter 15)
dups
  Duplicate processing (chapter 16)
transactions
  Performing transactions (chapter 17)
apache
  Web programming using Apache (Perl, PHP, Python, chapters 18-20)
tomcat
  Web programming using Tomcat (Java/JSP, chapters 18-20)
admin
  MySQL administration (chapter 22)
misc
  Miscellaneous stuff

Other files:

setCLASSPATH
  Example tcsh/csh script for setting CLASSPATH (to use it, execute
  this command: source setCLASSPATH)

To install a script or program for general use, put it in a directory
that is listed in your PATH setting.  (PATH settings are discussed
in chapter 1, Recipe 1.3.)  For example, under Unix, you might put a script in
/usr/local/bin, or in the bin directory under your home directory.

Web scripts should be installed according to the instructions given
in the book.

You should also set your environment to name the relevant directories
where you install library files from the book (for example, chapter
2, Recipe 2.3).  Suppose that you put the library files in
/usr/local/lib/mcb.  For tcsh, you might set the environment like
this:

setenv PERLLIB /usr/local/lib/mcb
setenv RUBYLIB /usr/local/lib/mcb
setenv PYTHONPATH /usr/local/lib/mcb

For Bourne shells:

export PERLLIB=/usr/local/lib/mcb
export RUBYLIB=/usr/local/lib/mcb
export PYTHONPATH=/usr/local/lib/mcb

For PHP, modify your system's php.ini to include the directory where
you install PHP library files.  (Set the value of the include_path
directive.)

For Java, set the CLASSPATH environment variable.

Files often contain lines with "#@ _IDENTIFIER_" sequences.  These
may be ignored. They are just placemarkers, used to block out
sections that are used for examples in the book (I have tools that
look for them and pull sections of code into the book).

You'll note that many of the Perl scripts include lines that look like this:

{ # begin scope
} # end scope

Their purpose is to enable similar examples within the same file that
use the same variables all to declare the variables with "my".  By
introducing a new scope for each example, the declarations don't trigger
warnings from Perl.

----------------------------------------------------------------------
Some important differences between the recipes distributions for the
second and third editions:

Note 1:

If you have the second edition of MySQL Cookbook, be warned that
the PHP and Python library files in the third edition have the same
names as in the first edition, but are incompatible with them. If
you use any PHP or Python scripts that depend on the second edition
library files, they will break if you install the third edition
library files on top of them. Use the following procedure to prevent
this from happening for the PHP files. (A similar procedure applies
for the Python files.)



1. Change location into the directory where you installed the second
   edition library files and make a copy of each one:

   % cp Cookbook.php Cookbook2.php
   % cp Cookbook_Utils.php Cookbook_Utils2.php
   % cp Cookbook_Webutils.php Cookbook_Webutils2.php
   % cp Cookbook_Session.php Cookbook_Session2.php

2. Find any PHP scripts that include the second edition library
   files, and change them to include the *2.php files instead.  For
   example, a script that includes Cookbook_Utils.php should be changed
   to include Cookbook_Utils2.php.  (Some of the library files themselves
   include other library files, so you'll also need to edit the *2.php
   files.)

3. Test the modified scripts to make sure that they work correctly
   with the *2.php files.

Now you can install the third edition library files on top of the
second edition files that have the same names.  PHP scripts from
the third edition will use these new library files, and old scripts
should continue to work correctly.
----------------------------------------------------------------------
