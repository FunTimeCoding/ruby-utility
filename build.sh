#!/bin/sh -e

while true; do
    case ${1} in
        -w|--workspace)
            WORKSPACE="${2-}"
            shift 2
            ;;
        -h|--help)
            echo "Usage: [-h][-c|--clean][-v|--verbose][-w|--workspace WORKSPACE]"
            exit 0
            ;;
        -c|--clean)
            CLEAN=1
            shift
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        --)
            shift
            break
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
    DIR=$(dirname "${0}")
    SCRIPT_DIR=$(cd "${DIR}"; pwd)
    WORKSPACE="${SCRIPT_DIR}"
fi

echo "WORKSPACE: ${WORKSPACE}"

if [ "${CLEAN}" = "1" ]; then
    "${WORKSPACE}/clear-cache.sh"
fi

"${WORKSPACE}/run-style-check.sh" --ci-mode
"${WORKSPACE}/run-metrics.sh" --ci-mode
"${WORKSPACE}/run-tests.sh" --ci-mode
