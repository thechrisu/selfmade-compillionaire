#!/usr/bin/env python3
#
# This script checks whether the file names of the test suite match
# their results as reported by the reference compiler.
#
# It assumes that "make test" has been run and reads result.csv. If
# there are any p-files that did not report "parsing successful", or any
# n-files that did, it prints out their names.

from re import match
from sys import stderr

with open("result.csv") as f:
    lines = f.readlines()

# Lines are either the name of a test file, or an output. This variable
# switches between None and the name of the last test file we've seen.
test_file = None

# Is the last test that we've seen supposed to pass?
positive = False

output = []

for line in lines:
    line = line.strip()
    m = match("tests/\w+/(?P<expected>[pn]).+", line)
    if m:
        test_file = line
        positive =  m.group("expected") == "p"
    else:
        # We're looking at an output line. If we've just seen a file
        # name, check if the output matches our expectations; otherwise,
        # we've already seen the first line of output, so continue.
        if test_file:
            if line == "parsing successful":
                if not positive:
                    output.append("%s %s" % (test_file, line))
            else:
                if positive:
                    output.append("%s %s" % (test_file, line))
            test_file = None
        else:
            continue

if output:
    print("\nERROR: Some test cases disagree with the compiler:",
          file=stderr)
    for o in output:
        print("  %s" % o, file=stderr)
    print("", file=stderr)
    exit(1)
