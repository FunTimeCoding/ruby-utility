#!/bin/sh -e

CLEAN=0

while true; do
    case ${1} in
        -h|--help)
            echo "Usage: [-h|--help][-d|--debug][-c|--clean][-w|--workspace WORKSPACE]"

            exit 0
            ;;
        -d|--debug)
            set -x
            shift
            ;;
        -c|--clean)
            CLEAN=1
            shift
            ;;
        -w|--workspace)
            WORKSPACE="${2-}"
            shift 2
            ;;
        *)
            if [ ! "${1}" = "" ]; then
                echo "Unknown option: ${1}"
            fi

            break
            ;;
    esac
done

if [ "${WORKSPACE}" = "" ]; then
    DIRECTORY=$(dirname "${0}")
    SCRIPT_DIRECTORY=$(cd "${DIRECTORY}"; pwd)
    WORKSPACE="${SCRIPT_DIRECTORY}"
fi

echo "WORKSPACE: ${WORKSPACE}"

if [ "${CLEAN}" = "1" ]; then
    "${WORKSPACE}"/clear-cache.sh
fi

"${WORKSPACE}"/run-style-check.sh --ci-mode
"${WORKSPACE}"/run-metrics.sh --ci-mode
"${WORKSPACE}"/run-tests.sh --ci-mode
