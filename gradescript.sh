#!/bin/bash

function usage {
    echo "usage: ./gradescript.sh <path to your memhier> <path to ref memhier>"
    echo "    **Note: this script must be in the root directory for the tests.**"
    exit 0
}

if [ $# -ne 2 ]; then
    usage
fi

YOUR_MEMHIER=$1
REF_MEMHIER=$2

TESTS=("test0" "test1" "test2")
TEST_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


