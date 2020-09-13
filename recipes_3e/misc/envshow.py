#!/usr/bin/python
# envshow.py: show environment values

import os

print("user: %d" % os.geteuid())
keys = os.environ.keys()
keys.sort()
for k in keys:
  print("%s: %s" % (k, os.environ[k]))
