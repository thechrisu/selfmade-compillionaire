#!/bin/bash 

#######################################################################
#
# Description of this script:
#
# This script recursively runs all tests from the specified directory
# or file.
#
#######################################################################

program_name=$0
default_test_dir="./tests/custom/"
temp_file="./test.temp"

# Success by default
exit_code=0

# Colors
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
RESET="\033[0m"

function usage {
    echo "usage: $program_name <mode> [path]"
    echo "      <mode>  'all', 'dir' or 'one':"
    echo "                  'all' - runs all tests from '$default_test_dir'"
    echo "                  'dir' - runs all tests from directory at [path]"
    echo "                  'one' - runs test file at [path]"
    echo "      [path]   path to test directory or test file"
}

function separator {
    neutral "■━━━━━━━━━━━━━■"
}

function pre_test {
    separator
    neutral "Rebuilding project before testing..."
    separator
    echo ""
    make clean
    local clean_status=$?
    make
    local make_status=$?
    if [ ${clean_status} -ne 0 ] || [ ${make_status} -ne 0 ]
    then
        neutral ""
        separator
        danger "Failed to make project! Testing aborted."
        separator
        exit 1
    fi
}

function post_test {
    rm -f ${temp_file}
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

function count_tests {
    local dir=$1
    local counter=0
    for test_file in ${dir}*.s
    do
        if [ -f "${test_file}" ]
        then
            counter=$((counter+1))
        fi
    done
    echo ${counter}
}

function count_dirs {
    local dir=$1
    local counter=0
    for test_dir in ${dir}*/
    do
        if [ -d "${test_dir}" ]
        then
            counter=$((counter+1))
        fi
    done
    echo ${counter}
}

function ensure_trailing_slash {
    local dir=$1
    local dir_length=$((${#dir}-1))
    local last_char=${dir:${dir_length}:1}
    if [ ! ${last_char} == "/" ]
    then
        dir="$dir/"
    fi
    echo ${dir}
}

function run_test_dir {
    local indent=$1
    local dir=$(ensure_trailing_slash $2)

    local test_count=$(count_tests ${dir})
    local dir_count=$(count_dirs ${dir})
    local symbol="┏"
    if [ "$(($test_count+$dir_count))" -eq "0" ]
    then
        symbol="■"
    fi

    echo ""
    neutral "$indent$symbol━■ $dir [$test_count tests]"

    local index=0
    for testfile in ${dir}*.s
    do
        if [ -f "$testfile" ]
        then
            index=$((index+1))
            local symbol="┣"
            if [ "$index" -eq "$test_count" ]
            then
                symbol="┗"
            fi
            run_test_file "$indent$symbol━━ " "$indent    ┗ " ${testfile}
        fi
    done
    for testdir in $dir*/
    do
        if [ -d "$testdir" ]
        then
            run_test_dir "  $indent" ${testdir}
        fi
    done
}

function run_test_file {
    local indent=$1
    local errindent=$2
    local filepath=$3
    local filename=$(basename ${filepath})
    local type=${filename:0:1}
    local command="java -cp bin/:lib/java-cup-11b-runtime.jar SC $filepath"

    out=$(eval "${command}" 2> ${temp_file})
    err=$(cat ${temp_file})
    if [[ "$type" == "p" && "$out" == *"parsing successful"* ]] || [[ "$type" == "n" && ! "$out" == *"parsing successful"* ]]
    then
        success "${indent}PASS $filename"
    else
        danger "${indent}FAIL $filename"
        danger "${errindent}Error: $err"
        exit_code=1
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

pre_test
neutral ""
separator
neutral "Starting tests!"
separator

# Run all tests
if [ "$1" == "all" ]
then
    run_test_dir "" ${default_test_dir}
fi

# Run tests dir
if [ "$1" == "dir" ]
then
    if [ ! -d "$2" ]
    then
        echo "'$2' is not a directory!"
        exit 1
    else
        run_test_dir "" $2
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
        run_test_file "" "" $2
    fi
fi

post_test

exit ${exit_code}
