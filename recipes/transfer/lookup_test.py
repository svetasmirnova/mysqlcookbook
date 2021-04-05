#!/usr/bin/python
# lookup_test.py: Demonstrate use of dictionary for lookup/validation purposes.

# create dictionary, add members to it, using values as keys

members = {"pig": 1, "cat": 1, "duck": 1, "dog": 1}

# show list of legal values

print("Legal values: %s" % " ".join(members.keys()))

# test some values to see whether they're in the dictionary

print("Test some values:")
for val in ("cat", "snake"):
  if members.has_key(val):
    goodbad = "good"
  else:
    goodbad = "bad"
  print("%s (%s)" % (val, goodbad))
