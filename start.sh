#!/bin/bash
set -e
source ./sconification/env.sh
source ./sgx_device.sh


function message() {
echo ""
echo ""
echo "$1 "
echo ""
}

function print_message {
    local MESSAGE=$1
    echo -e "${MESSAGE}" 1>&2
}

function usage() {
    print_message "Usage $(basename ${BASH_SOURCE[0]}) [-h ] [-x] [-v] [-a] [-c] [-C] [-g] [-j] [-J] [-p] [-n] [-i]

Supported examples are: C-binaryFS, C++-binaryFS, go-fspf, java8-fspfs, java11-fspf
                                          python-binaryFS, node-binaryFS.
        \nSwitches:
        -h\tPrint this message and exit
        -x\tEnable debug mode
        -v\tEnable verbose mode (print Dockerfile and session of sconified image)
        -a\tRun all examples
        -c\tRun C examples (default example)
        -C\tRun C++ examples
        -g\tRun Go examples
        -j\tRun java11 exampless
        -J\tRun java8 examples
        -p\tRun Python examples
        -p\tRun Node examples
        -i\tName of sconify image
        "
}

SWITCH_VERBOSE="no"
export SWITCH_C="no"
export SWITCH_CPP="no"
export SWITCH_GO="no"
export SWITCH_JAVA11="no"
export SWITCH_JAVA8="no"
export SWITCH_PYTHON="no"
export SWITCH_NODE="no"
export SWITCH_DEBUG="no"
export SWITCH_VERBOSE="no"


while getopts ":hxvacCgjJpni:" opt; do
    case ${opt} in
        \?)
            usage
            exit 1
            ;;
        h)
            usage
            exit 1
            ;;
        x)
            set -x
            export SWITCH_DEBUG="yes"
            ;;
        v)
            export SWITCH_VERBOSE="yes"
            ;;
        a)
            export SWITCH_C="yes"
            export SWITCH_CPP="yes"
            export SWITCH_GO="yes"
            export SWITCH_JAVA11="yes"
            export SWITCH_JAVA8="yes"
            export SWITCH_PYTHON="yes"
            export SWITCH_NODE="yes"
            ;;
        c)
            export SWITCH_C="yes"
            ;;
        C)
            export SWITCH_CPP="yes"
            ;;
        g)
            export SWITCH_GO="yes"
            ;;
        j)
            export SWITCH_JAVA11="yes"
            ;;
        J)
            export SWITCH_JAVA8="yes"
            ;;
        p)
            export SWITCH_PYTHON="yes"
            ;;
        n)
            export SWITCH_NODE="yes"
            ;;
        i) 
            SCONIFY_IMAGE="${OPTARG}"
            ;;
 esac
done


docker pull ${SCONIFY_IMAGE} || (echo "You need access to registry.scontain.com:5050" && exit 1)

determine_sgx_device                
docker-compose down                 
docker-compose run build_and_sconify
if [[ "$SWITCH_C" == "yes" ]] 
then
    docker-compose run c_native           && message "C native image is done!"
    docker-compose run c_scone_binaryfs   && message "C SCONE binaryFS image is done!" 
fi

if [[ "$SWITCH_CPP" == "yes" ]]
then
    docker-compose run cpp_native         && message "CPP native image is done!"
    docker-compose run cpp_scone_binaryfs && message "CPP SCONE binaryFS image is done!"
fi

if [[ "$SWITCH_GO" == "yes" ]]
then
    docker-compose run go_native          && message "GO native image is done!"
    docker-compose run go_scone_fspf      && message "GO SCONE FSPF image is done!"
fi

if [[ "$SWITCH_JAVA11" == "yes" ]]
then
    docker-compose run java_native        && message "Java native image is done!"
    docker-compose run java_scone_fspf    && message "Java SCONE FSPF image is done!"
    message "Java with binaryFS image could take a while to run. Please wait!!"
    docker-compose run java_scone_binaryfs && message "Java SCONE binaryFS image is done!"
fi

if [[ "$SWITCH_JAVA8" == "yes" ]]
then
    docker-compose run java8_native       && message "Java8 native image is done!"
    docker-compose run java8_scone_fspf   && message "Java8 SCONE FSPF image is done!"
    message "Java with binaryFS image could take a while to run. Please wait!"
    docker-compose run java8_scone_binaryfs && message "Java SCONE binaryFS image is done!"
fi

if [[ "$SWITCH_PYTHON" == "yes" ]]
then
    docker-compose run python_native      && message "Python native image is done!"
    docker-compose run python_scone_binfs && message "Python SCONE binaryFS image is done!"
fi

if [[ "$SWITCH_NODE" == "yes" ]]
then
    echo "Pulling precompiled node14 binary"
    docker pull registry.scontain.com:5050/sconecuratedimages/node:14.4.0-alpine3.11
    docker-compose run node_native      && message "Node native image is done!"
    docker-compose run node_scone_binfs && message "Node SCONE binaryFS image is done!"
fi