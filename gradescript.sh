#!/bin/bash

function usage {
    echo "usage: ./gradescript.sh <path to your memhier> <path to ref memhier>"
    echo "   or: ./gradescript.sh clean"
    echo "    **Note: this script must be in the root directory for the tests.**"
    exit 0
}

TESTS=("test0" "test1" "test2" "test3" "test4" "test5" "test6" "test7" "test8" "test9" "test10" "test11" "test12" "test13" "test14" "test15" "test16" "test17" "test18") # "test19" "test20")
TEST_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -lt 1 ]; then
    usage
fi

if [ $1 = "clean" ]; then
    curr_dir=$(pwd)
    for test_name in "${TESTS[@]}"; do
        cd $TEST_ROOT_DIR/$test_name
        rm yours.stdout yours.stderr ref.stdout ref.stderr diff.stdout diff.stderr trace.log >/dev/null 2>&1
        cd $curr_dir
    done
    exit 0
fi

if [ $# -ne 2 ]; then
    usage
fi

YOUR_MEMHIER=$1
REF_MEMHIER=$2

memhier_base=$(dirname $YOUR_MEMHIER)
YOUR_MEMHIER_NAME=$(basename $YOUR_MEMHIER)
curr_dir=$(pwd)
cd $memhier_base
memhier_base=$(pwd)
cd $curr_dir
YOUR_MEMHIER="$memhier_base/$YOUR_MEMHIER_NAME"

memhier_base=$(dirname $REF_MEMHIER)
REF_MEMHIER_NAME=$(basename $REF_MEMHIER)
curr_dir=$(pwd)
cd $memhier_base
memhier_base=$(pwd)
cd $curr_dir
REF_MEMHIER="$memhier_base/$REF_MEMHIER_NAME"

curr_dir=$(pwd)

for test_name in "${TESTS[@]}"; do
    cp $YOUR_MEMHIER $TEST_ROOT_DIR/$test_name
    cp $REF_MEMHIER $TEST_ROOT_DIR/$test_name
    cd $TEST_ROOT_DIR/$test_name
    rm yours.stdout yours.stderr ref.stdout ref.stderr diff.stdout diff.stderr trace.log >/dev/null 2>&1
    ./$YOUR_MEMHIER_NAME < trace.dat > yours.stdout 2> yours.stderr
    ./$REF_MEMHIER_NAME < trace.dat > ref.stdout 2> ref.stderr
    echo "$test_name:"
    diff -u ref.stdout yours.stdout > diff.stdout
    if [ $? -eq 0 ]; then
        echo "    Stdout: Success"
    else
        echo "    Stdout: Failure"
    fi
    diff -u ref.stderr yours.stderr > diff.stderr
    if [ $? -eq 0 ]; then
        echo "    Stderr: Success"
    else
        echo "    Stderr: Failure"
    fi
    echo ""
    rm $YOUR_MEMHIER_NAME $REF_MEMHIER_NAME
    cd $curr_dir
done
