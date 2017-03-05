#!/usr/bin/env bash

#######################################################################
#
# create-graph.sh - UCL CS COMP207P Graph Generator
# Timur Kuzhagaliyev 2017, https://foxypanda.me/
#
#######################################################################
#
# Description of this script:
#
# Run the script without any arguments to see help.
#
# Generates a graph of the tree generated while parsing the source file.
# The resulting PNG file is saved using the name of the test file and
# can be found in the `graphs` directory.
#
#######################################################################

program_name=$0

function usage {
    echo "usage: $program_name <test-path>"
    echo "      <test-path> path to a test file"
}

graph="digraph G {"
graph="$graph$(java -cp bin:lib/java-cup-11b-runtime.jar SC $1)" 
graph="$graph}"
echo "$graph" | dot -Tpng > "./graphs/$(basename ${1}).png"
