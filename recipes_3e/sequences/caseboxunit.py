#!/usr/bin/python
# caseboxunit.py

# Generate case, box, and unit numbers for sequentially packed items.
# There are 12 units per box (1 through 12), 6 boxes per case (1 through 6).
# The case numbers increase sequentially without bound.

# This just tests the equations for generating the proper values.

print("sequence  case   box  unit")

for seq in (1, 12, 13, 72, 73, 144):
#@ _DECOMPOSE_
  unit_num = ((seq - 1) % 12) + 1
  box_num = (int ((seq - 1) / 12) % 6) + 1
  case_num = int ((seq - 1)/(6 * 12)) + 1
#@ _DECOMPOSE_
  print("%8d    %2d    %2d    %2d" % (seq, case_num, box_num, unit_num))
