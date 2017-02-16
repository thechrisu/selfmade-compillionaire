#!/bin/bash 

#######################################################################
#
# Description of this script:
#
# This script recursively runs all tests from the specified directory
# or file.
#
#######################################################################

programname=$0
defaultdir="./tests/custom/"
testtempfile="./test.temp"

# Success by default
exitcode=0

# Colors
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
RESET="\033[0m"

function usage {
    echo "usage: $programname <mode> [path]"
    echo "      <mode>  'all', 'dir' or 'one':"
    echo "                  'all' - runs all tests from '$defaultdir'"
    echo "                  'dir' - runs all tests from directory at [path]"
    echo "                  'one' - runs test file at [path]"
    echo "      [path]   path to test directory or test file"
}

function pretest {
    make clean
    make
}
function success {
    /bin/echo -e "$GREEN$1$RESET"
}
function warning {
    /bin/echo -e "$YELLOW$1$RESET"
}
function danger {
    /bin/echo -e "$RED$1$RESET"
}
function neutral {
    /bin/echo -e "$CYAN$1$RESET"
}

function rundir {
    local indent=$1
    local newindent="  $indent"
    local dir=$2

    # Add a trailing slash to `$dir` if it's not there
    local dirlength=$((${#dir}-1))
    local dirlastchar=${dir:$dirlength:1} 
    if [ ! $dirlastchar == "/" ]
    then
        dir="$dir/"
    fi

    neutral "$indent┏$dir"
    local counter=0
    for testfile in $dir*.s
    do
        counter=$((counter+1))
    done
    local index=0
    for testfile in $dir*.s
    do
        if [ -f "$testfile" ]
        then
            index=$((index+1))
            local symbol="┣"
            if [ "$index" -eq "$counter" ]
            then
                symbol="┗"
            fi
            runfile "$indent$symbol━━ " "$indent    ┗ " $testfile 
        fi
    done
    for testdir in $dir*/
    do
        if [ -d "$testdir" ]
        then
            rundir "$newindent" $testdir
        fi
    done
}

function runfile {
    local indent=$1
    local errindent=$2
    local filepath=$3
    local filename=$(basename $filepath)
    local type=${filename:0:1}
    local command="java -cp bin/:lib/java-cup-11b-runtime.jar SC $filepath"

    out=$(eval "$command" 2> $testtempfile)
    err=$(cat $testtempfile)
    if [[ "$type" == "p" && "$out" == *"parsing successful"* ]] || [[ "$type" == "n" && ! "$out" == *"parsing successful"* ]]
    then
        success "${indent}PASS $filename"
    else
        danger "${indent}FAIL $filename"
        danger "${errindent}Error: $err"
        exitcode=1
    fi
}

# Print usage instructions if no arguments are supplied
if [ "$#" -eq 0 ]
then
    usage
    exit 0
fi

# Check that the mode is correct
if [ "$1" != "all" ] && [ "$1" != "dir" ] && [ "$1" != "one" ]
then
    echo "Invalid mode!"
    exit 1
fi

# Check that the amount of arguments is correct
if [[ ("$1" == "dir" || "$1" == "one") && (! "$#" -eq 2) ]] || [[ "$1" == "all" && (! "$#" -eq 1) ]]
then
    echo "Invalid amount of arguments!"
    exit 1
fi

pretest

# Run all tests
if [ "$1" == "all" ]
then
    rundir "" $defaultdir
fi

# Run tests dir
if [ "$1" == "dir" ]
then
    if [ ! -d "$2" ]
    then
        echo "'$2' is not a directory!"
        exit 1
    else
        rundir "" $2
    fi
fi

# Run test file
if [ "$1" == "one" ]
then
    if [ ! -f "$2" ]
    then
        echo "'$2' is not a file!"
        exit 1
    else
        runfile "" "" $2
    fi
fi

exit $exitcode
